import { Injectable } from "@nestjs/common";
import { Cron, CronExpression } from "@nestjs/schedule";
import { PrismaService } from "../prisma.service";

@Injectable()
export class MembershipTask {
    constructor(private prisma: PrismaService) { }

    @Cron(CronExpression.EVERY_HOUR)
    async handleCron() {
        const now = new Date();

        const expired = await this.prisma.membership.updateMany({
            where: {
                status: 'ACTIVE',
                endDate: { lt: now }
            },
            data: {
                status: 'EXPIRED'
            }
        });

        if (expired.count > 0) {
            console.log(`🧹 [CRON] ${expired.count} membership telah expired secara otomatis.`);
        }
    }
}