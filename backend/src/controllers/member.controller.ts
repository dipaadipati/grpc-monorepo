import { Controller } from "@nestjs/common";
import { RpcException } from "@nestjs/microservices";
import * as grpc from "@grpc/grpc-js";
import * as bcrypt from 'bcrypt';
import { create } from "@bufbuild/protobuf";
import { PrismaService } from "../prisma.service.js";
import {
    RegisterMemberRequest,
    UpdateMemberRequest,
    UserProfileSchema
} from "@/gen/app_pb";
import { kUser } from "../auth/auth.interceptor.js";
import { InjectRedis } from '@nestjs-modules/ioredis';
import Redis from 'ioredis';
import { timestampFromDate } from "@bufbuild/protobuf/wkt";
import { sanitizeNull } from "@/utils/prisma-sanitize.js";

@Controller()
export class MemberController {
    constructor(private prisma: PrismaService, @InjectRedis() private readonly redis: Redis) { }

    async createMember(data: RegisterMemberRequest, context: any) {
        const { email, password, name } = data;

        const user = context.values.get(kUser);

        if (!user.tenantIsActive) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin karena cabang telah dinonaktifkan. Silakan hubungi administrator sistem atau tim teknis terkait untuk mendapatkan akses lebih lanjut.'
            });
        }

        if (name == '') {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi nama lengkap dengan benar.'
            });
        }

        if (email == '') {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi email dengan benar.'
            });
        }

        if (password == '') {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi password dengan benar.'
            });
        }

        const adminTenantId = user?.tenantId;
        const adminRole = user?.role;

        if (!adminTenantId || (adminRole !== 'OWNER' && adminRole !== 'ADMIN_STAFF' && adminRole !== 'SUPER_ADMIN')) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin untuk mendaftarkan member di cabang ini.',
            });
        }

        const existingUser = await this.prisma.user.findUnique({ where: { email } });
        if (existingUser) {
            throw new RpcException({
                code: grpc.status.ALREADY_EXISTS,
                message: 'Email sudah terdaftar di sistem.',
            });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const newUser = await this.prisma.user.create({
            data: {
                email,
                password: hashedPassword,
                name,
                role: 'MEMBER',
                tenantId: adminTenantId,
            },
            include: { tenant: true }
        });

        const cacheKey = `gym:${user.tenantId}:members`;
        await this.redis.del(cacheKey);

        console.log(`🧹 [REDIS] Cache members dihapus untuk tenant: ${user.tenantId}`);

        return create(UserProfileSchema, {
            id: newUser.id,
            email: newUser.email,
            name: newUser.name,
            role: newUser.role,
            tenantId: newUser.tenantId,
            tenantName: newUser.tenant.name
        });
    }

    async *getMembers(context: any) {
        const user = context.values.get(kUser);
        const cacheKey = `gym:${user.tenantId}:members`;

        const cachedData = await this.redis.get(cacheKey);

        if (cachedData) {
            console.log("⚡ [REDIS] Mengambil data members dari Cache");
            const members = JSON.parse(cachedData);
            for (const m of members) yield m;
            return;
        }

        console.log("🐢 [DB] Cache members kosong, ambil dari PostgreSQL");
        const members = await this.prisma.user.findMany({
            where: { tenantId: user.tenantId, role: 'MEMBER' },
            include: { tenant: true, membership: true },
            orderBy: { createdAt: 'desc' }
        });

        await this.redis.set(cacheKey, JSON.stringify(members), 'EX', 300);

        for (const m of members) {
            yield create(UserProfileSchema, sanitizeNull({
                ...m,
                membership: m.membership ? {
                    ...m.membership,
                    startDate: timestampFromDate(m.membership.startDate),
                    endDate: timestampFromDate(m.membership.endDate),
                } : undefined,
                createdAt: timestampFromDate(m.createdAt),
            }));
        }
    }

    async updateMember(req: UpdateMemberRequest, context: any) {
        const user = context.values.get(kUser);

        if (!user.tenantIsActive) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin karena cabang telah dinonaktifkan. Silakan hubungi administrator sistem atau tim teknis terkait untuk mendapatkan akses lebih lanjut.'
            });
        }

        if (req.name == '') {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi nama lengkap dengan benar.'
            });
        }

        if (req.email == '') {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi email dengan benar.'
            });
        }

        if (req.password == '') {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi password dengan benar.'
            });
        }

        const cacheKey = `gym:${user.tenantId}:members`;

        if (user.tenantId !== user.tenantId || (user.role !== 'OWNER' && user.role !== 'ADMIN_STAFF' && user.role !== 'SUPER_ADMIN' && user.sub !== req.id)) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin untuk mengedit member di cabang ini.',
            });
        }

        const updated = await this.prisma.user.update({
            where: {
                id: req.id,
                tenantId: user.tenantId
            },
            data: {
                name: req.name,
                email: req.email,
                ...(req.password && { password: req.password })
            }
        });

        await this.redis.del(cacheKey);
        console.log(`🧹 Cache dihapus setelah edit member: ${req.id}`);

        return create(UserProfileSchema, {
            ...updated,
            createdAt: timestampFromDate(updated.createdAt),
        });
    }

    async deleteMember(req: any, context: any) {
        const user = context.values.get(kUser);

        if (!user.tenantIsActive) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin karena cabang telah dinonaktifkan. Silakan hubungi administrator sistem atau tim teknis terkait untuk mendapatkan akses lebih lanjut.'
            });
        }

        const cacheKey = `gym:${user.tenantId}:members`;

        if (user.tenantId !== user.tenantId || (user.role !== 'OWNER' && user.role !== 'ADMIN_STAFF' && user.role !== 'SUPER_ADMIN')) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin untuk menghapus member di cabang ini.',
            });
        }

        await this.prisma.user.delete({
            where: {
                id: Number(req.memberId),
                tenantId: user.tenantId
            }
        });

        await this.redis.del(cacheKey);
        console.log(`🧹 Cache dihapus setelah delete member: ${req.memberId}`);
        return {};
    }

    async getMemberProfile(context: any) {
        const curUser = context.values.get(kUser);

        if (!curUser.tenantIsActive) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin karena cabang telah dinonaktifkan. Silakan hubungi administrator sistem atau tim teknis terkait untuk mendapatkan akses lebih lanjut.'
            });
        }

        const userId = curUser?.sub;

        const user = await this.prisma.user.findUnique({
            where: { id: userId },
            include: { tenant: true }
        });

        if (!user) {
            throw new RpcException({
                code: grpc.status.NOT_FOUND,
                message: 'User tidak ditemukan.',
            });
        }

        return create(UserProfileSchema, {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
            tenantId: user.tenantId,
            tenantName: user.tenant.name
        });
    }
}