import { Interceptor, ConnectError, Code, createContextKey } from "@connectrpc/connect";
import * as grpc from "@grpc/grpc-js";
import { RpcException } from "@nestjs/microservices";
import Redis from "ioredis";

export interface UserPayload {
    sub: number;
    email: string;
    role: string;
    tenantId: number;
}

export const kUser = createContextKey<UserPayload | undefined>(undefined);

const PUBLIC_METHODS = [
    "app.AuthService/Login",
];

export const createAuthInterceptor = (redis: Redis): Interceptor => {
    return (next) => async (req) => {
        const methodName = req.service.typeName + "/" + req.method.name;
        console.log(`🔐 [Auth Interceptor] Method called: ${methodName}`);

        if (PUBLIC_METHODS.includes(methodName)) {
            console.log(`✅ [Auth Interceptor] Public method, skipping auth`);
            return await next(req);
        }

        const authHeader = req.header.get("Authorization");
        console.log(`🔍 [Auth Interceptor] Auth header: ${authHeader ? "Present" : "Missing"}`);

        if (!authHeader || !authHeader.startsWith("Bearer ")) {
            console.error(`❌ [Auth Interceptor] No valid Bearer token`);
            throw new ConnectError("Unauthenticated: No token provided", Code.Unauthenticated);
        }

        const token = authHeader.replace("Bearer ", "");
        console.log(`🔍 [Auth Interceptor] Token: ${token.substring(0, 8)}...`);

        try {
            const session = await redis.get(`token:${token}`);
            console.log(`🔍 [Auth Interceptor] Redis lookup: ${session ? "Found" : "Not found"}`);

            if (!session) {
                console.error(`❌ [Auth Interceptor] Token not found in Redis`);
                throw new ConnectError("Unauthenticated: Invalid or expired token", Code.Unauthenticated);
            }

            const payload: UserPayload = JSON.parse(session);
            console.log(`✅ [Auth Interceptor] Auth success for user: ${payload.email}`);

            const newContextValues = req.contextValues.set(kUser, payload);

            return await next({
                ...req,
                contextValues: newContextValues
            });
        } catch (err: any) {
            if (err instanceof ConnectError) {
                throw err;
            }

            console.error(`❌ [Auth Interceptor] Error: ${err.message}`);
            const message = err.message || "Internal Error";

            let connectCode = Code.Internal;
            const grpcCode = err.error?.code ?? err.code;

            if (grpcCode === grpc.status.PERMISSION_DENIED) {
                connectCode = Code.PermissionDenied;
            } else if (grpcCode === grpc.status.UNAUTHENTICATED) {
                connectCode = Code.Unauthenticated;
            }

            throw new ConnectError(message, connectCode);
        }
    };
};

export const extractUserSession = async (request: any, context: any, redis: Redis): Promise<any> => {
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
                const sessionStr = await redis.get(`token:${token}`);
                if (sessionStr) {
                    const sessionData = JSON.parse(sessionStr);
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