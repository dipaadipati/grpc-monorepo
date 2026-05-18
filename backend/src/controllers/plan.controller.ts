import { Controller } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { InjectRedis } from '@nestjs-modules/ioredis';
import Redis from 'ioredis';
import {
    AddPlanRequest,
    UpdatePlanRequest,
    GetPlanRequest,
    PlanResponseSchema,
    PlanSchema
} from '@shared/app_pb.js';
import { create } from '@bufbuild/protobuf';
import { RpcException } from '@nestjs/microservices';
import * as grpc from '@grpc/grpc-js';
import { kUser } from '../auth/auth.interceptor';
import { Prisma } from '../../generated/prisma/client';
import { timestampFromDate } from '@bufbuild/protobuf/wkt';

@Controller()
export class PlanController {
    constructor(
        private prisma: PrismaService,
        @InjectRedis() private readonly redis: Redis,
    ) { }

    private getCacheKey(tenantId: number) {
        return `gym:${tenantId}:plans`;
    }

    async addPlan(req: AddPlanRequest, context: any) {
        const user = context.values.get(kUser);

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

    async updatePlan(req: UpdatePlanRequest, context: any) {
        const user = context.values.get(kUser);

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

    async deletePlan(req: GetPlanRequest, context: any) {
        const user = context.values.get(kUser);

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

    async *getPlans(context: any) {
        const user = context.values.get(kUser);
        const cacheKey = this.getCacheKey(user.tenantId);

        const cached = await this.redis.get(cacheKey);
        if (cached) {
            const plans = JSON.parse(cached);
            for (const p of plans) yield create(PlanSchema, p);
            return;
        }

        const plans = await this.prisma.membershipPlan.findMany({
            where: { tenantId: user.tenantId },
            include: { tenant: true },
            orderBy: { price: 'asc' }
        });

        const mappedPlans = plans.map(p => ({
            id: p.id,
            name: p.name,
            price: BigInt(Math.round(Number(p.price))),
            duration: p.duration,
            tenantId: p.tenantId,
            tenant: {
                id: p.tenant.id,
                name: p.tenant.name,
                slug: p.tenant.slug
            }
        }));

        await this.redis.set(cacheKey, JSON.stringify(mappedPlans), 'EX', 3600);

        for (const p of mappedPlans) {
            yield create(PlanSchema, p);
        }
    }

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
            tenant: {
                ...p.tenant,
                createdAt: timestampFromDate(p.tenant.createdAt)
            }
        });
    }
}