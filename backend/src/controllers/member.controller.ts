import { Controller } from "@nestjs/common";
import { GrpcMethod, RpcException } from "@nestjs/microservices";
import * as grpc from "@grpc/grpc-js";
import * as bcrypt from 'bcrypt';
import { create } from "@bufbuild/protobuf";
import { PrismaService } from "../prisma.service.js";
import {
    type RegisterMemberRequest,
    type UpdateMemberRequest,
    UserProfileSchema
} from "@/gen/app_pb";
import { kUser } from "../auth/auth.interceptor.js";
import { InjectRedis } from '@nestjs-modules/ioredis';
import Redis from 'ioredis';
import { timestampFromDate } from "@bufbuild/protobuf/wkt";
import { sanitizeNull } from "@/utils/prisma-sanitize.js";
import { serializeBigInt } from "@/utils/common.js";

@Controller()
export class MemberController {
    constructor(private prisma: PrismaService, @InjectRedis() private readonly redis: Redis) { }

    private async extractUserSession(request: any, context: any): Promise<any> {
        if (context && context.values && typeof context.values.get === 'function') {
            return context.values.get(kUser);
        }

        let metadata: grpc.Metadata | null = null;
        if (context && typeof context.get === 'function') {
            metadata = context;
        } else if (request && typeof request.getArgByIndex === 'function') {
            metadata = request.getArgByIndex(1);
        }

        if (metadata) {
            const authHeader = (metadata.get('authorization')?.[0] || metadata.get('Authorization')?.[0]) as string;
            if (authHeader && authHeader.startsWith('Bearer ')) {
                const token = authHeader.replace('Bearer ', '').trim();
                const sessionStr = await this.redis.get(`token:${token}`);
                if (sessionStr) {
                    const sessionData = JSON.parse(sessionStr);
                    // Sesuaikan struktur payload agar mirip dengan yang disimpan interceptor Svelte
                    return {
                        ...sessionData,
                        tenantId: sessionData.tenantId,
                        role: sessionData.role,
                        tenantIsActive: sessionData.tenantIsActive ?? true,
                        sub: sessionData.sub
                    };
                }
            }
        }

        throw new RpcException({
            code: grpc.status.UNAUTHENTICATED,
            message: 'Sesi tidak valid atau telah kedaluwarsa.',
        });
    }

    @GrpcMethod('MemberService', 'RegisterMember')
    async createMember(data: RegisterMemberRequest, context: any) {
        const user = await this.extractUserSession(data, context);
        const { email, password, name } = data;

        if (!user.tenantIsActive) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin karena cabang telah dinonaktifkan. Silakan hubungi administrator sistem atau tim teknis terkait untuk mendapatkan akses lebih lanjut.'
            });
        }

        if (name == '') {
            throw new RpcException({ code: grpc.status.INVALID_ARGUMENT, message: 'Mohon isi nama lengkap dengan benar.' });
        }
        if (email == '') {
            throw new RpcException({ code: grpc.status.INVALID_ARGUMENT, message: 'Mohon isi email dengan benar.' });
        }
        if (password == '') {
            throw new RpcException({ code: grpc.status.INVALID_ARGUMENT, message: 'Mohon isi password dengan benar.' });
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
            throw new RpcException({ code: grpc.status.ALREADY_EXISTS, message: 'Email sudah terdaftar di sistem.' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);

        const newUser = await this.prisma.user.create({
            data: { email, password: hashedPassword, name, role: 'MEMBER', tenantId: adminTenantId },
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

    @GrpcMethod('MemberService', 'GetMembers')
    async getMembers(request: any, context: any) { // 🚀 Hapus tanda bintang (*)
        const user = await this.extractUserSession(request, context);
        const cacheKey = `gym:${user.tenantId}:members`;

        const isConnectRpc = context && context.values && typeof context.values.get === 'function';

        if (isConnectRpc) {
            const cachedData = await this.redis.get(cacheKey);
            if (cachedData) {
                console.log("⚡ [REDIS] Mengambil data members dari Cache");
                const membersArray = JSON.parse(cachedData);
                return { members: membersArray };
            }
        }

        console.log("🐢 [DB] Mengambil data members dari PostgreSQL");
        const dbMembers = await this.prisma.user.findMany({
            where: { tenantId: user.tenantId, role: 'MEMBER' },
            include: { tenant: true, membership: true },
            orderBy: { createdAt: 'desc' }
        });

        const formattedMembers = dbMembers.map((m) => {
            return {
                id: Number(m.id),
                email: m.email || '',
                name: m.name || '',
                role: m.role || '',
                tenantId: Number(m.tenantId) || 0,
                tenantName: m.tenant?.name || '',
                tenantIsActive: m.tenant?.isActive ?? true,
                midtransClientKey: process.env.MIDTRANS_CLIENT_KEY || '',
                createdAt: timestampFromDate(new Date(m.createdAt)),
                membership: m.membership ? {
                    id: m.membership.id,
                    userId: m.membership.userId,
                    planId: m.membership.planId,
                    status: m.membership.status,
                    startDate: timestampFromDate(new Date(m.membership.startDate)),
                    endDate: timestampFromDate(new Date(m.membership.endDate)),
                } : undefined
            };
        });

        const safeDbMembers = serializeBigInt(formattedMembers);
        await this.redis.set(cacheKey, JSON.stringify(safeDbMembers), 'EX', 300);

        if (isConnectRpc) {
            console.log("🌐 [GetMembers] Return array format Connect RPC");
            const connectMembers = formattedMembers.map(m => create(UserProfileSchema, sanitizeNull(m)));
            return { members: connectMembers };
        } else {
            console.log("📱 [GetMembers] Return array format Native gRPC Plain Object");
            return { members: formattedMembers };
        }
    }

    @GrpcMethod('MemberService', 'UpdateMember')
    async updateMember(req: UpdateMemberRequest, context: any) {
        const user = await this.extractUserSession(req, context);

        if (!user.tenantIsActive) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin karena cabang telah dinonaktifkan. Silakan hubungi administrator sistem atau tim teknis terkait untuk mendapatkan akses lebih lanjut.'
            });
        }

        if (req.name == '') {
            throw new RpcException({ code: grpc.status.INVALID_ARGUMENT, message: 'Mohon isi nama lengkap dengan benar.' });
        }
        if (req.email == '') {
            throw new RpcException({ code: grpc.status.INVALID_ARGUMENT, message: 'Mohon isi email dengan benar.' });
        }

        const cacheKey = `gym:${user.tenantId}:members`;
        const currentUserId = user.id || user.sub;

        if (user.role !== 'OWNER' && user.role !== 'ADMIN_STAFF' && user.role !== 'SUPER_ADMIN' && currentUserId !== req.id) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin untuk mengedit member di cabang ini.',
            });
        }

        const updated = await this.prisma.user.update({
            where: { id: req.id, tenantId: user.tenantId },
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
            createdAt: timestampFromDate(new Date(updated.createdAt)),
        });
    }

    @GrpcMethod('MemberService', 'DeleteMember')
    async deleteMember(req: any, context: any) {
        const user = await this.extractUserSession(req, context);

        if (!user.tenantIsActive) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin karena cabang telah dinonaktifkan. Silakan hubungi administrator sistem atau tim teknis terkait untuk mendapatkan akses lebih lanjut.'
            });
        }

        const cacheKey = `gym:${user.tenantId}:members`;

        if (user.role !== 'OWNER' && user.role !== 'ADMIN_STAFF' && user.role !== 'SUPER_ADMIN') {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin untuk menghapus member di cabang ini.',
            });
        }

        await this.prisma.user.delete({
            where: { id: Number(req.memberId), tenantId: user.tenantId }
        });

        await this.redis.del(cacheKey);
        console.log(`🧹 Cache dihapus setelah delete member: ${req.memberId}`);
        return {};
    }

    @GrpcMethod('MemberService', 'GetMemberProfile')
    async getMemberProfile(request: any, context: any) {
        const curUser = await this.extractUserSession(request, context);

        if (!curUser.tenantIsActive) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin karena cabang telah dinonaktifkan. Silakan hubungi administrator sistem atau tim teknis terkait untuk mendapatkan akses lebih lanjut.'
            });
        }

        const userId = curUser?.id || curUser?.sub;

        const user = await this.prisma.user.findUnique({
            where: { id: userId },
            include: { tenant: true }
        });

        if (!user) {
            throw new RpcException({ code: grpc.status.NOT_FOUND, message: 'User tidak ditemukan.' });
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