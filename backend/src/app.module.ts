import { Module } from '@nestjs/common';
import { AuthController } from './controllers/auth.controller';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { PrismaService } from './prisma.service';
import { MemberController } from './controllers/member.controller';
import { RedisModule } from '@nestjs-modules/ioredis';
import { TenantController } from './controllers/tenant.controller';
import { PlanController } from './controllers/plan.controller';
import { TransactionController } from './controllers/transaction.controller';
import { PaymentController } from './controllers/payment.controller';
import { MembershipService } from './services/membership.service';
import { ScheduleModule } from '@nestjs/schedule';
import { OfferingController } from './controllers/offering.controller';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    RedisModule.forRootAsync({
      imports: [ConfigModule, ScheduleModule.forRoot()],
      inject: [ConfigService],
      useFactory: async (configService: ConfigService) => {
        const host = configService.get<string>('REDIS_HOST') || 'gym-redis-container';
        const port = configService.get<number>('REDIS_PORT') || 6379;

        console.log(`[Redis Debug] Mencoba connect ke Host: ${host}, Port: ${port}`);

        return {
          type: 'single',
          url: `redis://${host}:${port}`,
          options: {
            host: host,
            port: Number(port),
            retryStrategy(times) {
              const delay = Math.min(times * 50, 2000);
              return delay;
            },
          },
          onClientReady: (client) => {
            console.log('[Redis Debug] Jembatan onClientReady aktif.');

            client.on('error', (err) => {
              console.error('[Redis Debug] TERDETEKSI ERROR ASLI:', {
                message: err.message,
                stack: err.stack,
              });
            });

            client.on('connect', () => {
              console.log('[Redis Debug] Berhasil terkoneksi ke server Redis!');
            });
          },
        };
      },
    }),
  ],
  controllers: [
    AuthController,
    MemberController,
    TenantController,
    PlanController,
    TransactionController,
    PaymentController,
    OfferingController,
  ],
  providers: [PrismaService, MembershipService]
})
export class AppModule { }
