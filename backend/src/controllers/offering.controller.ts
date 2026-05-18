import { Controller } from "@nestjs/common";
import { RpcException } from "@nestjs/microservices";
import * as grpc from "@grpc/grpc-js";
import * as bcrypt from 'bcrypt';
import { create } from "@bufbuild/protobuf";
import { PrismaService } from "../prisma.service.js";
import {
    AddOfferingRequest,
    GetOfferingRequest,
    OfferingResponseSchema,
    OfferingSchema,
    UpdateOfferingRequest,
} from "@shared/app_pb.js";
import { kUser } from "../auth/auth.interceptor.js";
import { InjectRedis } from '@nestjs-modules/ioredis';
import Redis from 'ioredis';
import { OfferingType } from "../../generated/prisma/enums.js";
import { Prisma } from "../../generated/prisma/client.js";

@Controller()
export class OfferingController {
    constructor(private prisma: PrismaService, @InjectRedis() private readonly redis: Redis) { }

    async createOffering(data: AddOfferingRequest, context: any) {
        const { name, price, type, duration, stock, quota } = data;

        const user = context.values.get(kUser);

        if (!user.tenantIsActive) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin karena cabang telah dinonaktifkan. Silakan hubungi administrator sistem atau tim teknis terkait untuk mendapatkan akses lebih lanjut.'
            });
        }

        if (type === 'MEMBERSHIP' && duration <= 0) {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi durasi membership dengan benar.'
            });
        } else if (type === 'SERVICE' && quota <= 0) {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi quota PT dengan benar.'
            });
        }

        if (price <= 0) {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi harga dengan benar.'
            });
        }

        const adminTenantId = user?.tenantId;
        const adminRole = user?.role;

        if (!adminTenantId || (adminRole !== 'OWNER' && adminRole !== 'ADMIN_STAFF' && adminRole !== 'SUPER_ADMIN')) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin untuk menambahkan offering di cabang ini.',
            });
        }

        const newOffering = await this.prisma.offering.create({
            data: {
                name,
                price: new Prisma.Decimal(price.toString()),
                type: type as OfferingType,
                duration,
                stock,
                quota,
                tenantId: adminTenantId
            }
        });

        const cacheKey = `gym:${user.tenantId}:offerings`;
        await this.redis.del(cacheKey);

        console.log(`🧹 [REDIS] Cache offerings dihapus untuk tenant: ${user.tenantId}`);

        return create(OfferingSchema, { ...newOffering });
    }

    async *getOfferings(context: any) {
        const user = context.values.get(kUser);
        const cacheKey = `gym:${user.tenantId}:offerings`;

        const cachedData = await this.redis.get(cacheKey);

        if (cachedData) {
            console.log("⚡ [REDIS] Mengambil data offerings dari Cache");
            const offerings = JSON.parse(cachedData);
            for (const o of offerings) yield o;
            return;
        }

        console.log("🐢 [DB] Cache offerings kosong, ambil dari PostgreSQL");
        const offerings = await this.prisma.offering.findMany({
            where: { tenantId: user.tenantId },
            include: { tenant: true },
            orderBy: { name: 'asc' }
        });

        await this.redis.set(cacheKey, JSON.stringify(offerings), 'EX', 300);

        for (const o of offerings) {
            yield create(OfferingSchema, { ...o, price: new Prisma.Decimal(o.price.toString()) });
        }
    }

    async updateOffering(req: UpdateOfferingRequest, context: any) {
        const user = context.values.get(kUser);

        if (!user.tenantIsActive) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin karena cabang telah dinonaktifkan. Silakan hubungi administrator sistem atau tim teknis terkait untuk mendapatkan akses lebih lanjut.'
            });
        }

        if (req.type === 'MEMBERSHIP' && req.duration <= 0) {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi durasi membership dengan benar.'
            });
        } else if (req.type === 'SERVICE' && req.quota <= 0) {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi quota PT dengan benar.'
            });
        }

        if (req.price <= 0) {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi harga dengan benar.'
            });
        }

        const cacheKey = `gym:${user.tenantId}:offerings`;

        if (user.tenantId !== user.tenantId || (user.role !== 'OWNER' && user.role !== 'ADMIN_STAFF' && user.role !== 'SUPER_ADMIN' && user.sub !== req.id)) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin untuk mengedit offering di cabang ini.',
            });
        }

        const updated = await this.prisma.offering.update({
            where: {
                id: req.id,
                tenantId: user.tenantId
            },
            data: {
                name: req.name,
                price: String(req.price),
                type: req.type as OfferingType,
                duration: req.duration,
                stock: req.stock,
                quota: req.quota
            }
        });

        await this.redis.del(cacheKey);
        console.log(`🧹 Cache dihapus setelah edit offering: ${req.id}`);

        return create(OfferingResponseSchema, {
            offeringId: updated.id,
        });
    }

    async deleteOffering(req: GetOfferingRequest, context: any) {
        const user = context.values.get(kUser);

        if (!user.tenantIsActive) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin karena cabang telah dinonaktifkan. Silakan hubungi administrator sistem atau tim teknis terkait untuk mendapatkan akses lebih lanjut.'
            });
        }

        const cacheKey = `gym:${user.tenantId}:offerings`;

        if (user.tenantId !== user.tenantId || (user.role !== 'OWNER' && user.role !== 'ADMIN_STAFF' && user.role !== 'SUPER_ADMIN')) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin untuk menghapus offering di cabang ini.',
            });
        }

        await this.prisma.offering.delete({
            where: {
                id: Number(req.offeringId),
                tenantId: user.tenantId
            }
        });

        await this.redis.del(cacheKey);
        console.log(`🧹 Cache dihapus setelah delete offering: ${req.offeringId}`);
        return {};
    }

    async getOffering(req: GetOfferingRequest, context: any) {
        const user = context.values.get(kUser);

        if (user.tenantId !== user.tenantId || (user.role !== 'OWNER' && user.role !== 'ADMIN_STAFF' && user.role !== 'SUPER_ADMIN')) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin untuk melihat offering di cabang ini.',
            });
        }

        const offering = await this.prisma.offering.findFirst({
            where: {
                id: req.offeringId,
                tenantId: user.tenantId
            },
            include: { tenant: true }
        });

        if (!offering) {
            throw new RpcException({
                code: grpc.status.NOT_FOUND,
                message: 'Offering tidak ditemukan di cabang ini.',
            });
        }

        return create(OfferingSchema, { ...offering, price: new Prisma.Decimal(offering.price.toString()) });
    }
}