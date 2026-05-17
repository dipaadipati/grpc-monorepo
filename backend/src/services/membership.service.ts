import { Injectable } from '@nestjs/common';
import { PrismaService } from '../prisma.service';

@Injectable()
export class MembershipService {
    constructor(private prisma: PrismaService) { }

    async activateMembership(userId: number, planId?: number, offeringId?: number) {
        if (planId) {
            const plan = await this.prisma.membershipPlan.findUnique({ where: { id: planId } });
            const currentMembership = await this.prisma.membership.findFirst({ where: { userId }, orderBy: { createdAt: 'desc' } })
            const endDate = currentMembership && currentMembership.status === 'ACTIVE' ? currentMembership.endDate : new Date();
            endDate.setDate(endDate.getDate() + plan!.duration);

            return await this.prisma.membership.upsert({
                where: { userId: userId },
                update: {
                    planId: planId,
                    status: 'ACTIVE',
                    endDate: endDate,
                },
                create: {
                    userId: userId,
                    planId: planId,
                    status: 'ACTIVE',
                    endDate: endDate,
                },
            });
        } else if (offeringId) {
            const offering = await this.prisma.offering.findUnique({ where: { id: offeringId } })
            if (offeringId && !offering?.duration) {
                return false;
            }
            const currentMembership = await this.prisma.membership.findFirst({ where: { userId }, orderBy: { createdAt: 'desc' } })
            const endDate = currentMembership && currentMembership.status === 'ACTIVE' ? currentMembership.endDate : new Date();
            endDate.setDate(endDate.getDate() + offering!.duration!);

            return await this.prisma.membership.upsert({
                where: { userId: userId },
                update: {
                    planId: planId,
                    offeringId: offeringId,
                    status: 'ACTIVE',
                    endDate: endDate,
                },
                create: {
                    userId: userId,
                    offeringId: offeringId,
                    status: 'ACTIVE',
                    endDate: endDate,
                },
            });
        } else {
            return false;
        }
    }
}