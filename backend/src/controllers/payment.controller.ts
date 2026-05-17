import { Body, Controller, Post } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { InjectRedis } from '@nestjs-modules/ioredis';
import Redis from 'ioredis';
import { MembershipService } from '../services/membership.service';

@Controller()
export class PaymentController {
    constructor(private prisma: PrismaService, private membershipService: MembershipService, @InjectRedis() private readonly redis: Redis) { }

    @Post('webhook')
    async handleWebhook(@Body() notification: any) {
        const orderId = notification.order_id;

        const transaction = await this.prisma.transaction.findUnique({
            where: { id: orderId },
            include: { user: true }
        });

        if (!transaction) {
            return { status: 'error', message: `Transaksi dengan ID ${orderId} tidak ditemukan.` };
        }

        if (transaction.status === 'SETTLEMENT') {
            return { status: 'ok', message: 'Sudah diproses' };
        }

        const transactionStatus = notification.transaction_status;

        if (transactionStatus === 'settlement' || transactionStatus === 'capture') {
            const trx = await this.prisma.transaction.update({
                where: { id: orderId },
                data: { status: 'SETTLEMENT' }
            });

            if (trx.planId) {
                await this.membershipService.activateMembership(trx.userId, trx.planId);
            }

            await this.redis.del(`gym:${transaction.user.tenantId}:members`);
        }
        return { status: 'ok' };
    }
}