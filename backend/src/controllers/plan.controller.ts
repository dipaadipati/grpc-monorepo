import { Controller } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { InjectRedis } from '@nestjs-modules/ioredis';
import Redis from 'ioredis';
import type {
    AddPlanRequest,
    UpdatePlanRequest,
    GetPlanRequest
} from '@/gen/app_pb';
import {
    PlanResponseSchema,
    PlanSchema
} from '@/gen/app_pb';
import { create } from '@bufbuild/protobuf';
import { GrpcMethod, RpcException } from '@nestjs/microservices';
import * as grpc from '@grpc/grpc-js';
import { extractUserSession, kUser } from '../auth/auth.interceptor';
import { Prisma } from '../../generated/prisma/client';
import { timestampFromDate } from '@bufbuild/protobuf/wkt';
import { sanitizeNull } from '@/utils/prisma-sanitize';
import { serializeBigInt } from '@/utils/common';

@Controller()
export class PlanController {
    constructor(
        private prisma: PrismaService,
        @InjectRedis() private readonly redis: Redis,
    ) { }

    private getCacheKey(tenantId: number) {
        return `gym:${tenantId}:plans`;
    }

    @GrpcMethod('PlanService', 'AddPlan')
    async addPlan(req: AddPlanRequest, context: any) {
        const user = await extractUserSession(req, context, this.redis);

        if (!user.tenantIsActive) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin karena cabang telah dinonaktifkan. Silakan hubungi administrator sistem atau tim teknis terkait untuk mendapatkan akses lebih lanjut.'
            });
        }

        if (req.price <= 0) {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi harga dengan benar.'
            });
        }

        if (req.duration <= 0) {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi durasi dengan benar.'
            });
        }

        const targetTenantId = user.role === 'SUPER_ADMIN' ? req.tenantId : user.tenantId;

        const newPlan = await this.prisma.membershipPlan.create({
            data: {
                name: req.name,
                price: new Prisma.Decimal(req.price.toString()),
                duration: req.duration,
                tenantId: targetTenantId,
            },
        });

        await this.redis.del(this.getCacheKey(targetTenantId));

        return create(PlanResponseSchema, { planId: newPlan.id.toString() });
    }

    @GrpcMethod('PlanService', 'UpdatePlan')
    async updatePlan(req: UpdatePlanRequest, context: any) {
        const user = await extractUserSession(req, context, this.redis);

        if (!user.tenantIsActive) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin karena cabang telah dinonaktifkan. Silakan hubungi administrator sistem atau tim teknis terkait untuk mendapatkan akses lebih lanjut.'
            });
        }

        if (req.price <= 0) {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi harga dengan benar.'
            });
        }

        if (req.duration <= 0) {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Mohon isi durasi dengan benar.'
            });
        }

        const existingPlan = await this.prisma.membershipPlan.findUnique({
            where: { id: req.id }
        });

        if (!existingPlan || existingPlan.tenantId !== user.tenantId && user.role !== 'SUPER_ADMIN') {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin mengubah paket ini.'
            });
        }

        const updated = await this.prisma.membershipPlan.update({
            where: { id: req.id },
            data: {
                name: req.name,
                price: new Prisma.Decimal(req.price.toString()),
                duration: req.duration,
            },
        });

        await this.redis.del(this.getCacheKey(updated.tenantId));

        return create(PlanResponseSchema, { planId: updated.id.toString() });
    }

    @GrpcMethod('PlanService', 'DeletePlan')
    async deletePlan(req: GetPlanRequest, context: any) {
        const user = await extractUserSession(req, context, this.redis);

        if (!user.tenantIsActive) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin karena cabang telah dinonaktifkan. Silakan hubungi administrator sistem atau tim teknis terkait untuk mendapatkan akses lebih lanjut.'
            });
        }

        await this.prisma.membershipPlan.deleteMany({
            where: {
                id: req.planId,
                ...(user.role !== 'SUPER_ADMIN' && { tenantId: user.tenantId })
            }
        });

        await this.redis.del(this.getCacheKey(user.tenantId));
        return {};
    }

    @GrpcMethod('PlanService', 'GetPlans')
    async getPlans(request: any, context: any) {
        const user = await extractUserSession(request, context, this.redis);

        if (!user) {
            throw new RpcException({
                code: grpc.status.UNAUTHENTICATED,
                message: 'Akses ditolak! Sesi tidak valid atau telah kedaluwarsa.',
            });
        }

        const cacheKey = this.getCacheKey(user.tenantId);
        const cached = await this.redis.get(cacheKey);
        if (cached) {
            console.log('⚡ [REDIS] Serving Plans from cache untuk Svelte Web');
            const plansArray = JSON.parse(cached);
            return { plans: plansArray };
        }

        console.log(`🐢 [DB] Menarik data plans dari PostgreSQL untuk cabang tenant: ${user.tenantId}`);
        const plans = await this.prisma.membershipPlan.findMany({
            where: { tenantId: user.tenantId },
            include: { tenant: true },
            orderBy: { price: 'asc' }
        });

        const mappedPlans = plans.map(p => ({
            id: Number(p.id),
            name: p.name || '',
            price: BigInt(Math.round(Number(p.price))),
            duration: p.duration || 0,
            tenantId: Number(p.tenantId),
            tenant: {
                id: Number(p.tenant.id),
                name: p.tenant.name || '',
                slug: p.tenant.slug || ''
            }
        }));

        const safeDbPlans = serializeBigInt(mappedPlans);
        await this.redis.set(cacheKey, JSON.stringify(safeDbPlans), 'EX', 3600);

        const connectPlans = mappedPlans.map(p => create(PlanSchema, sanitizeNull(p)));
        return { plans: connectPlans };
    }

    @GrpcMethod('PlanService', 'GetPlan')
    async getPlan(req: GetPlanRequest) {
        const p = await this.prisma.membershipPlan.findUnique({
            where: { id: req.planId },
            include: { tenant: true }
        });

        if (!p) throw new RpcException({ code: grpc.status.NOT_FOUND, message: 'Paket tidak ditemukan' });

        return create(PlanSchema, {
            id: p.id,
            name: p.name,
            price: BigInt(Math.round(Number(p.price))),
            duration: p.duration,
            tenantId: p.tenantId,
            tenant: sanitizeNull({
                ...p.tenant,
                createdAt: timestampFromDate(new Date(p.tenant.createdAt))
            })
        });
    }
}