import { Controller } from "@nestjs/common";
import { GrpcMethod, RpcException } from "@nestjs/microservices";
import * as grpc from "@grpc/grpc-js";
import * as bcrypt from 'bcrypt';
import { create } from "@bufbuild/protobuf";
import { PrismaService } from "../prisma.service.js";
import type {
    AddOfferingRequest,
    GetOfferingRequest,
    UpdateOfferingRequest,
} from "@/gen/app_pb";
import {
    OfferingResponseSchema,
    OfferingSchema,
} from "@/gen/app_pb";
import { extractUserSession, kUser } from "../auth/auth.interceptor.js";
import { InjectRedis } from '@nestjs-modules/ioredis';
import Redis from 'ioredis';
import { OfferingType } from "../../generated/prisma/enums.js";
import { Prisma } from "../../generated/prisma/client.js";
import { sanitizeNull } from "@/utils/prisma-sanitize.js";
import { serializeBigInt } from "@/utils/common.js";

@Controller()
export class OfferingController {
    constructor(private prisma: PrismaService, @InjectRedis() private readonly redis: Redis) { }

    @GrpcMethod('OfferingService', 'CreateOffering')
    async createOffering(data: AddOfferingRequest, context: any) {
        const { name, price, type, duration, stock, quota } = data;

        const user = await extractUserSession(data, context, this.redis);

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

        return create(OfferingSchema, sanitizeNull({
            ...newOffering,
            price: BigInt(Math.round(Number(newOffering.price))),
        }));
    }

    @GrpcMethod('OfferingService', 'GetOfferings')
    async getOfferings(request: any, context: any) { // 🚀 Hapus tanda bintang (*)
        const user = await extractUserSession(request, context, this.redis);

        if (!user) {
            throw new RpcException({
                code: grpc.status.UNAUTHENTICATED,
                message: 'Akses ditolak! Sesi tidak valid atau telah kedaluwarsa.',
            });
        }

        const cacheKey = `gym:${user.tenantId}:offerings`;

        const cachedData = await this.redis.get(cacheKey);
        if (cachedData) {
            console.log("⚡ [REDIS] Mengambil data offerings dari Cache untuk Svelte Web");
            const offeringsArray = JSON.parse(cachedData);
            return { offerings: offeringsArray };
        }

        console.log(`🐢 [DB] Cache offerings kosong, menarik dari PostgreSQL untuk cabang: ${user.tenantId}`);
        const dbOfferings = await this.prisma.offering.findMany({
            where: { tenantId: user.tenantId },
            include: { tenant: true },
            orderBy: { name: 'asc' }
        });

        const formattedOfferings = dbOfferings.map((o) => {
            return {
                id: Number(o.id),
                name: o.name || '',
                price: BigInt(Math.round(Number(o.price))),
                type: o.type || '',
                duration: o.duration || 0,
                stock: o.stock || 0,
                quota: o.quota || 0,
                tenantId: Number(o.tenantId),
            };
        });

        const safeDbOfferings = serializeBigInt(formattedOfferings);
        await this.redis.set(cacheKey, JSON.stringify(safeDbOfferings), 'EX', 300);

        const connectOfferings = formattedOfferings.map(o => create(OfferingSchema, sanitizeNull(o)));
        return { offerings: connectOfferings };
    }

    @GrpcMethod('OfferingService', 'UpdateOffering')
    async updateOffering(req: UpdateOfferingRequest, context: any) {
        const user = await extractUserSession(req, context, this.redis);

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

    @GrpcMethod('OfferingService', 'DeleteOffering')
    async deleteOffering(req: GetOfferingRequest, context: any) {
        const user = await extractUserSession(req, context, this.redis);

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

    @GrpcMethod('OfferingService', 'GetOffering')
    async getOffering(req: GetOfferingRequest, context: any) {
        const user = await extractUserSession(req, context, this.redis);

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

        return create(OfferingSchema, sanitizeNull({
            ...offering,
            price: BigInt(Math.round(Number(offering.price)))
        }));
    }
}