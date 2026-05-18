import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { expressConnectMiddleware } from '@connectrpc/connect-express';
import { registerConnectRoutes } from './connect-handler';
import { createAuthInterceptor } from './auth/auth.interceptor';
import { ConfigService } from '@nestjs/config';
import { getRedisConnectionToken } from '@nestjs-modules/ioredis';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const redis = app.get(getRedisConnectionToken());

  const configService = app.get(ConfigService);
  const port = configService.get('PORT') || 50051;

  app.enableCors({
    origin: 'http://localhost:5173',
    methods: 'POST,OPTIONS',
    allowedHeaders: ['Connect-Protocol-Version', 'Content-Type', 'Authorization'],
    exposedHeaders: ['Connect-Content-Encoding', 'Connect-Accept-Encoding'],
    credentials: true, // Enable cookies
  });

  app.enableCors({
    origin: 'https://grpc-monorepo.vercel.app',
    methods: 'POST,OPTIONS',
    allowedHeaders: ['Connect-Protocol-Version', 'Content-Type', 'Authorization'],
    exposedHeaders: ['Connect-Content-Encoding', 'Connect-Accept-Encoding'],
    credentials: true, // Enable cookies
  });

  app.use(expressConnectMiddleware({
    routes: (router) => registerConnectRoutes(app, router),
    interceptors: [createAuthInterceptor(redis)],
  }));

  await app.listen(port);
  console.log(`Backend gRPC/Connect ready on http://localhost:${port}`);
}
bootstrap();