import { Controller } from "@nestjs/common";
import { GrpcMethod, RpcException } from "@nestjs/microservices";
import * as grpc from "@grpc/grpc-js";
import * as bcrypt from 'bcrypt';
import { PrismaService } from "../prisma.service.js";
import { type LoginRequest, AuthResponseSchema, UserProfileSchema } from "@/gen/app_pb";
import { create } from "@bufbuild/protobuf";
import { v4 as uuidv4 } from 'uuid';
import { InjectRedis } from "@nestjs-modules/ioredis";
import Redis from "ioredis";
import { kUser } from "../auth/auth.interceptor.js";
import { timestampFromDate } from "@bufbuild/protobuf/wkt";
import { sanitizeNull } from "@/utils/prisma-sanitize.js";

@Controller()
export class AuthController {
    constructor(
        private prisma: PrismaService,
        @InjectRedis() private readonly redis: Redis
    ) { }

    @GrpcMethod('AuthService', 'Login')
    async login(data: LoginRequest) {
        const { email, password } = data;
        console.log("📥 [Login] Request masuk untuk email:", email);

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

        // Simpan token ke Redis dengan prefix token:
        await this.redis.set(
            `token:${sessionId}`,
            JSON.stringify(sessionData),
            'EX', 60 * 60 * 24
        );

        return create(AuthResponseSchema, {
            token: sessionId
        });
    }

    @GrpcMethod('AuthService', 'GetProfile')
    async getProfile(request: any, context: any) {
        console.log("🔍 [GetProfile] Menjalankan ekstraksi user session secara hybrid...");
        
        let userId: number | undefined;

        // 🛡️ STRATEGI 1: Cek apakah request datang dari Connect RPC (SvelteKit Web)
        if (context && context.values && typeof context.values.get === 'function') {
            console.log("🌐 [GetProfile] Mendeteksi traffic dari Connect RPC (SvelteKit Web)");
            const data = context.values.get(kUser);
            userId = data?.sub;
        } 
        
        // 📱 STRATEGI 2: Jika gagal, cek apakah dari Native gRPC (Flutter Mobile)
        // Objek 'context' pada microservice NestJS gRPC murni memiliki method 'getArgByIndex'
        else if (context && typeof context.getArgByIndex === 'function') {
            console.log("📱 [GetProfile] Mendeteksi traffic dari Native gRPC (Flutter Mobile)");
            
            // Indeks 1 pada gRPC native NestJS berisi objek Metadata asli
            const metadata: grpc.Metadata = context.getArgByIndex(1);
            
            // Ambil data header 'authorization' yang disuntikkan GrpcAuthInterceptor milik Flutter
            const authHeader = metadata.get('authorization')?.[0] as string;
            
            if (authHeader && authHeader.startsWith('Bearer ')) {
                const token = authHeader.replace('Bearer ', '');
                
                // Cari data session langsung ke Redis VPS
                const sessionStr = await this.redis.get(`token:${token}`);
                if (sessionStr) {
                    const sessionData = JSON.parse(sessionStr);
                    userId = sessionData.sub;
                    console.log(`✅ [GetProfile] Sesi Redis ditemukan untuk user ID: ${userId}`);
                } else {
                    console.error("❌ [GetProfile] Token Flutter tidak ditemukan atau kedaluwarsa di Redis");
                }
            } else {
                console.error("❌ [GetProfile] Header Authorization gRPC kosong atau salah format");
            }
        }

        // Jika kedua jalur gagal mendapatkan userId, lempar unauthenticated
        if (!userId) {
            throw new RpcException({
                code: grpc.status.UNAUTHENTICATED,
                message: 'Tidak terautentikasi atau sesi kedaluwarsa!',
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
            membership: user.membership ? sanitizeNull({
                ...user.membership,
                startDate: timestampFromDate(new Date(user.membership.startDate)),
                endDate: timestampFromDate(new Date(user.membership.endDate)),
            }) : undefined,
            createdAt: timestampFromDate(new Date(user.createdAt)),
            midtransClientKey: process.env.MIDTRANS_CLIENT_KEY || ''
        });
    }

    @GrpcMethod('AuthService', 'Logout')
    async logout(request: any, context: any) {
        let sessionId: string | undefined;

        // Penanganan Logout Hybrid
        if (context && context.values && typeof context.values.get === 'function') {
            const data = context.values.get(kUser);
            sessionId = data?.token;
        } else if (context && typeof context.getArgByIndex === 'function') {
            const metadata: grpc.Metadata = context.getArgByIndex(1);
            const authHeader = metadata.get('authorization')?.[0] as string;
            if (authHeader && authHeader.startsWith('Bearer ')) {
                sessionId = authHeader.replace('Bearer ', '');
            }
        }

        console.log("🔍 [Logout] Proses logout untuk session ID:", sessionId);

        if (sessionId) {
            console.log("🧹 [Logout] Menghapus token dari Redis:", sessionId);
            // Sesuai dengan set di Login (`token:${sessionId}`), maka hapusnya juga menggunakan prefix token:
            await this.redis.del(`token:${sessionId}`);
        }

        return { success: true };
    }
}