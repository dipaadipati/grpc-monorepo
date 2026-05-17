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
      useFactory: async (configService: ConfigService) => ({
        type: 'single',
        url: configService.get<string>('REDIS_URL'),
      }),
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
