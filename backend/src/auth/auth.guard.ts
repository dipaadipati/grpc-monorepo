import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { RpcException } from '@nestjs/microservices';
import * as grpc from '@grpc/grpc-js';
import Redis from 'ioredis';
import { UserPayload } from './auth.interceptor';

@Injectable()
export class AuthGuard implements CanActivate {
    constructor(private redis: Redis) { }

    async canActivate(context: ExecutionContext): Promise<boolean> {
        const rpcContext = context.switchToRpc();
        const metadata = rpcContext.getContext();
        const data = rpcContext.getData();

        const authHeader = metadata.get('authorization');

        if (!authHeader || authHeader.length === 0) {
            throw new RpcException({
                code: grpc.status.UNAUTHENTICATED,
                message: 'Missing Authorization Metadata',
            });
        }

        const authValue = authHeader[0] as string;
        const token = authValue.split(' ')[1] || authValue;

        try {
            const session = await this.redis.get(`token:${token}`);

            if (!session) {
                throw new RpcException({
                    code: grpc.status.UNAUTHENTICATED,
                    message: 'Token Invalid or Expired',
                });
            }

            const payload: UserPayload = JSON.parse(session);
            data.user = payload;

            return true;
        } catch (e) {
            throw new RpcException({
                code: grpc.status.UNAUTHENTICATED,
                message: 'Token Invalid or Expired',
            });
        }
    }
}