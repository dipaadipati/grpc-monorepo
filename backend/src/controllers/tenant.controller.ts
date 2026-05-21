import { Controller } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { InjectRedis } from '@nestjs-modules/ioredis';
import Redis from 'ioredis';
import type {
    AddTenantRequest,
    UpdateTenantRequest,
    GetTenantRequest,
} from '@/gen/app_pb';
import {
    TenantResponseSchema,
    TenantSchema
} from '@/gen/app_pb';
import { create } from '@bufbuild/protobuf';
import { GrpcMethod, RpcException } from '@nestjs/microservices';
import * as grpc from '@grpc/grpc-js';
import { extractUserSession, kUser } from '../auth/auth.interceptor';
import { timestampFromDate } from '@bufbuild/protobuf/wkt';
import { sanitizeNull } from '@/utils/prisma-sanitize';
import { serializeBigInt } from '@/utils/common';

@Controller()
export class TenantController {
    constructor(
        private prisma: PrismaService,
        @InjectRedis() private readonly redis: Redis,
    ) { }

    private readonly CACHE_KEY = 'global:tenants';

    @GrpcMethod('TenantService', 'AddTenant')
    async addTenant(req: AddTenantRequest, context: any) {
        const user = await extractUserSession(req, context, this.redis);

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

    @GrpcMethod('TenantService', 'UpdateTenant')
    async updateTenant(req: UpdateTenantRequest, context: any) {
        const user = await extractUserSession(req, context, this.redis);

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

    @GrpcMethod('TenantService', 'DeleteTenant')
    async deleteTenant(req: GetTenantRequest, context: any) {
        const user = await extractUserSession(req, context, this.redis);

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

    @GrpcMethod('TenantService', 'GetTenants')
    async getTenants(request: any, context: any) {
        const user = await extractUserSession(request, context, this.redis);

        if (!user) {
            throw new RpcException({
                code: grpc.status.UNAUTHENTICATED,
                message: 'Akses ditolak! Sesi tidak valid atau telah kedaluwarsa.',
            });
        }

        if (user.role !== 'SUPER_ADMIN') {
            throw new RpcException({
                code: grpc.status.PERMISSION_DENIED,
                message: 'Anda tidak memiliki izin untuk menghapus tenant.',
            });
        }

        console.log(`🔒 [GetTenants] Terautentikasi! User ${user.email || user.sub} berhasil masuk.`);

        const cached = await this.redis.get(this.CACHE_KEY);
        if (cached) {
            console.log('⚡ [REDIS] Serving Tenants from cache untuk Svelte Web');
            const tenantsArray = JSON.parse(cached);
            return { tenants: tenantsArray };
        }

        console.log(`🐢 [DB] Menarik data tenants dari PostgreSQL`);
        const dbTenants = await this.prisma.tenant.findMany({
            orderBy: { createdAt: 'desc' },
        });

        const formattedTenants = dbTenants.map((t) => {
            return {
                id: Number(t.id),
                name: t.name || '',
                slug: t.slug || '',
                address: t.address || '',
                isActive: t.isActive ?? false,
                createdAt: timestampFromDate(new Date(t.createdAt)),
            };
        });

        const safeDbTenants = serializeBigInt(formattedTenants);
        await this.redis.set(this.CACHE_KEY, JSON.stringify(safeDbTenants), 'EX', 3600);

        const connectTenants = formattedTenants.map(t => create(TenantSchema, sanitizeNull(t)));
        return { tenants: connectTenants };
    }

    @GrpcMethod('TenantService', 'GetTenant')
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

        return create(TenantSchema, sanitizeNull({
            ...tenant,
            createdAt: timestampFromDate(new Date(tenant.createdAt)),
        }));
    }
}