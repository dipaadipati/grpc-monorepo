import { Controller, Headers } from "@nestjs/common";
import { RpcException } from "@nestjs/microservices";
import * as grpc from "@grpc/grpc-js";
import * as bcrypt from 'bcrypt';
import { PrismaService } from "../prisma.service.js";
import { LoginRequest, AuthResponseSchema, UserProfileSchema } from "@shared/app_pb.js";
import { create } from "@bufbuild/protobuf";
import { v4 as uuidv4 } from 'uuid';
import { InjectRedis } from "@nestjs-modules/ioredis";
import Redis from "ioredis";
import { kUser } from "../auth/auth.interceptor.js";
import { timestampFromDate } from "@bufbuild/protobuf/wkt";

@Controller()
export class AuthController {
    constructor(
        private prisma: PrismaService,
        @InjectRedis() private readonly redis: Redis
    ) { }

    async login(data: LoginRequest) {
        const { email, password } = data;

        const user = await this.prisma.user.findUnique({
            where: { email },
            include: { tenant: true }
        });

        if (!user) {
            throw new RpcException({
                code: grpc.status.UNAUTHENTICATED,
                message: 'Email atau password salah!',
            });
        }

        const isPasswordValid = await bcrypt.compare(password, user.password);
        if (!isPasswordValid) {
            throw new RpcException({
                code: grpc.status.UNAUTHENTICATED,
                message: 'Email atau password salah!',
            });
        }
        const sessionId = uuidv4();

        const sessionData = {
            sub: user.id,
            email: user.email,
            role: user.role,
            tenantId: user.tenantId,
            tenantName: user.tenant.name,
            tenantIsActive: user.tenant.isActive,
            name: user.name,
            MIDTRANS_CLIENT_KEY: process.env.MIDTRANS_CLIENT_KEY || '',
            token: sessionId
        };

        await this.redis.set(
            `token:${sessionId}`,
            JSON.stringify(sessionData),
            'EX', 60 * 60 * 24
        );

        return create(AuthResponseSchema, {
            token: sessionId
        });
    }

    async getProfile(context: any) {
        console.log("🔍 [GetProfile] Fetching user profile from context...");
        const data = context.values.get(kUser);
        const userId = data?.sub;

        if (!userId) {
            throw new RpcException({
                code: grpc.status.UNAUTHENTICATED,
                message: 'Tidak terautentikasi!',
            });
        }

        const user = await this.prisma.user.findUnique({
            where: { id: userId },
            include: { tenant: true, membership: true }
        });

        if (!user) {
            throw new RpcException({
                code: grpc.status.NOT_FOUND,
                message: 'User tidak ditemukan!',
            });
        }

        return create(UserProfileSchema, {
            id: user.id,
            email: user.email,
            name: user.name,
            role: user.role,
            tenantId: user.tenantId,
            tenantName: user.tenant.name,
            tenantIsActive: user.tenant.isActive,
            membership: user.membership ? {
                ...user.membership,
                startDate: timestampFromDate(user.membership.startDate),
                endDate: timestampFromDate(user.membership.endDate),
            } : undefined,
            createdAt: timestampFromDate(user.createdAt),
            midtransClientKey: process.env.MIDTRANS_CLIENT_KEY || ''
        });
    }

    async logout(context: any) {
        const data = context.values.get(kUser);
        const sessionId = data?.token;
        console.log("🔍 [Logout] Logging out user with session ID:", sessionId);

        if (sessionId) {
            console.log("🧹 [Logout] Deleting session from Redis for session ID:", sessionId);
            await this.redis.del(`session:${sessionId}`);
        }

        return { success: true };
    }
}