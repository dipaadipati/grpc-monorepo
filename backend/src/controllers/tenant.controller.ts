import { Controller } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { InjectRedis } from '@nestjs-modules/ioredis';
import Redis from 'ioredis';
import {
    AddTenantRequest,
    UpdateTenantRequest,
    GetTenantRequest,
    TenantResponseSchema,
    TenantSchema
} from '@shared/app_pb';
import { create } from '@bufbuild/protobuf';
import { RpcException } from '@nestjs/microservices';
import * as grpc from '@grpc/grpc-js';
import { kUser } from '../auth/auth.interceptor';
import { timestampFromDate } from '@bufbuild/protobuf/wkt';

@Controller()
export class TenantController {
    constructor(
        private prisma: PrismaService,
        @InjectRedis() private readonly redis: Redis,
    ) { }

    private readonly CACHE_KEY = 'global:tenants';

    async addTenant(req: AddTenantRequest, context: any) {
        const user = context.values.get(kUser);

        if (process.env.IS_DEMO === 'TRUE') {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Ini adalah projek demo, anda tidak bisa menambahkan tenant',
            });
        }

        if (user?.role !== 'SUPER_ADMIN') {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin untuk menambahkan tenant.',
            });
        }

        const newTenant = await this.prisma.tenant.create({
            data: {
                name: req.name,
                slug: req.slug,
                address: req.address,
                isActive: req.isActive ?? true,
            },
        });

        await this.redis.del(this.CACHE_KEY);

        return create(TenantResponseSchema, { tenantId: newTenant.id.toString() });
    }

    async updateTenant(req: UpdateTenantRequest, context: any) {
        const user = context.values.get(kUser);

        if (process.env.IS_DEMO === 'TRUE') {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Ini adalah projek demo, anda tidak bisa mengubah tenant',
            });
        }

        if (user?.role !== 'SUPER_ADMIN' && user?.tenantId !== req.id) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin untuk mengupdate tenant.',
            });
        }

        const updated = await this.prisma.tenant.update({
            where: { id: req.id },
            data: {
                name: req.name,
                slug: req.slug,
                address: req.address,
                isActive: user?.role !== 'SUPER_ADMIN' ? undefined : req.isActive ?? true,
            },
        });

        await this.redis.del(this.CACHE_KEY);

        return create(TenantResponseSchema, { tenantId: updated.id.toString() });
    }

    async deleteTenant(req: GetTenantRequest, context: any) {
        const user = context.values.get(kUser);

        if (process.env.IS_DEMO === 'TRUE') {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Ini adalah projek demo, anda tidak bisa menghapus tenant',
            });
        }

        if (user?.role !== 'SUPER_ADMIN') {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin untuk menghapus tenant.',
            });
        }

        if (user.tenantId === req.tenantId) {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak dapat menghapus tenant milik Anda sendiri.',
            });
        }

        await this.prisma.tenant.delete({
            where: { id: req.tenantId },
        });

        await this.redis.del(this.CACHE_KEY);
        return {};
    }

    async *getTenants(context: any) {
        const cached = await this.redis.get(this.CACHE_KEY);
        if (cached) {
            console.log('⚡ [REDIS] Serving Tenants from cache');
            const tenants = JSON.parse(cached);
            for (const t of tenants) yield create(TenantSchema, t);
            return;
        }

        const tenants = await this.prisma.tenant.findMany({
            orderBy: { createdAt: 'desc' },
        });

        await this.redis.set(this.CACHE_KEY, JSON.stringify(tenants), 'EX', 3600);

        for (const t of tenants) {
            yield create(TenantSchema, {
                ...t,
                createdAt: timestampFromDate(t.createdAt),
            });
        }
    }

    async getTenant(req: GetTenantRequest, context: any) {
        const tenant = await this.prisma.tenant.findUnique({
            where: { id: req.tenantId },
        });

        if (!tenant) {
            throw new RpcException({
                code: grpc.status.NOT_FOUND,
                message: 'Tenant tidak ditemukan',
            });
        }

        return create(TenantSchema, {
            ...tenant,
            createdAt: timestampFromDate(tenant.createdAt),
        });
    }
}