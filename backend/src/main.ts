import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Transport, MicroserviceOptions } from '@nestjs/microservices';
import { expressConnectMiddleware } from '@connectrpc/connect-express';
import { registerConnectRoutes } from './connect-handler';
import { createAuthInterceptor } from './auth/auth.interceptor';
import { ConfigService } from '@nestjs/config';
import { getRedisConnectionToken } from '@nestjs-modules/ioredis';
import { join } from 'path';
import { existsSync } from 'fs';
import * as bodyParser from 'body-parser';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const redis = app.get(getRedisConnectionToken());
  const configService = app.get(ConfigService);
  
  const httpPort = 3000;
  const grpcPort = 50051;

  app.enableCors({
    origin: (origin: any, callback: any) => {
      const allowedOrigins = [
        'http://localhost:5173',
        'https://grpc-monorepo.vercel.app'
      ];
      if (!origin || allowedOrigins.indexOf(origin) !== -1) {
        callback(null, true);
      } else {
        callback(new Error('Blocked by CORS'));
      }
    },
    methods: 'POST,OPTIONS',
    allowedHeaders: ['Connect-Protocol-Version', 'Content-Type', 'Authorization'],
    exposedHeaders: ['Connect-Content-Encoding', 'Connect-Accept-Encoding'],
    credentials: true,
  });

  // app.use(bodyParser.raw({ type: 'application/proto' }));
  // app.use(bodyParser.raw({ type: 'application/connect+proto' }));

  app.use(expressConnectMiddleware({
    routes: (router) => registerConnectRoutes(app, router),
    interceptors: [createAuthInterceptor(redis)],
  }));

  const protoRoot = existsSync('/proto') ? '/proto' : join(__dirname, '../../proto');

  app.connectMicroservice<MicroserviceOptions>({
    transport: Transport.GRPC,
    options: {
      url: `0.0.0.0:${grpcPort}`,
      package: ['app'],
      protoPath: [
        join(protoRoot, 'app.proto'),
      ],
    },
  });

  await app.startAllMicroservices();
  await app.listen(httpPort);  
  
  console.log(`🚀 [HTTP Connect Server] Ready on http://localhost:${httpPort}`);
  console.log(`🛡️ [Native gRPC Server] Ready on port ${grpcPort} (HTTP/2 Biner)`);
}
bootstrap();