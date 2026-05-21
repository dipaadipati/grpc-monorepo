import { Controller } from '@nestjs/common';
import { PrismaService } from '../prisma.service';
import { create } from '@bufbuild/protobuf';
import { type CreateTransactionRequest, type GetTransactionsRequest, TransactionSchema } from '@/gen/app_pb';
import { GrpcMethod, RpcException } from '@nestjs/microservices';
import * as grpc from '@grpc/grpc-js';
import { v4 as uuidv4 } from 'uuid';
import { MembershipService } from '../services/membership.service';
import Redis from 'ioredis';
import { InjectRedis } from '@nestjs-modules/ioredis';
import { kUser } from '../auth/auth.interceptor';
import { timestampFromDate } from '@bufbuild/protobuf/wkt';
import { sanitizeNull } from '@/utils/prisma-sanitize';

const midtransClient = require('midtrans-client');

@Controller()
export class TransactionController {
    private coreApi = new midtransClient.CoreApi({
        isProduction: false,
        serverKey: process.env.MIDTRANS_SERVER_KEY,
        clientKey: process.env.MIDTRANS_CLIENT_KEY,
    });

    constructor(private prisma: PrismaService, private membershipService: MembershipService, @InjectRedis() private readonly redis: Redis) { }

    @GrpcMethod('TransactionService', 'CreateTransaction')
    async createTransaction(req: CreateTransactionRequest, context: any) {
        const user = context.values.get(kUser);

        const generateOrderId = (isPlan: boolean) => {
            const now = new Date();
            const dd = String(now.getDate()).padStart(2, '0');
            const mm = String(now.getMonth() + 1).padStart(2, '0');
            const yy = String(now.getFullYear()).slice(-2);
            const uuid = uuidv4().substring(0, 8).toUpperCase();
            return `${isPlan ? 'PLN' : 'OFR'}-${dd}${mm}${yy}-${uuid}`;
        };

        if (req.planId) {
            const activeMembership = await this.prisma.membership.findFirst({
                where: {
                    userId: req.memberId,
                    status: 'ACTIVE',
                    endDate: {
                        gt: new Date(),
                    },
                },
            });

            if (activeMembership) {
                throw new RpcException({
                    code: grpc.status.FAILED_PRECONDITION,
                    message: 'Member sudah memiliki membership aktif.',
                });
            }

            const plan = await this.prisma.membershipPlan.findUnique({
                where: { id: req.planId }
            });

            if (!plan) throw new RpcException({ code: grpc.status.NOT_FOUND, message: "Paket tidak ditemukan" });

            const orderId = generateOrderId(true);
            let qrisUrl = null;

            if (req.method === 'QRIS') {
                const parameter = {
                    payment_type: "qris",
                    transaction_details: {
                        order_id: orderId,
                        gross_amount: Number(plan.price),
                    },
                    usage_limit: 1
                };
                const response = await this.coreApi.charge(parameter);
                qrisUrl = response.actions?.find((a: any) => a.name === 'generate-qr-code')?.url;
            }

            const trx = await this.prisma.transaction.create({
                data: {
                    id: orderId,
                    userId: req.memberId,
                    planId: req.planId,
                    amount: plan.price,
                    method: req.method,
                    status: req.method === 'CASH' ? 'SETTLEMENT' : 'PENDING',
                    qrisUrl: qrisUrl,
                },
            });

            if (req.method === 'CASH') {
                await this.membershipService.activateMembership(req.memberId, req.planId);
                await this.redis.del(`gym:${user.tenantId}:members`);
            }

            return create(TransactionSchema, sanitizeNull({
                ...trx,
                amount: BigInt(trx.amount.toString()),
                createdAt: timestampFromDate(new Date(trx.createdAt)),
            }));
        } else if (req.offeringId) {
            const offering = await this.prisma.offering.findUnique({
                where: { id: req.offeringId }
            });
            if (!offering) throw new RpcException({ code: grpc.status.NOT_FOUND, message: "Offering tidak ditemukan" });

            const orderId = generateOrderId(false);
            let qrisUrl = null;

            if (req.method === 'QRIS') {
                const parameter = {
                    payment_type: "qris",
                    transaction_details: {
                        order_id: orderId,
                        gross_amount: offering.price.toNumber(),
                    },
                    usage_limit: 1
                };
                const response = await this.coreApi.charge(parameter);
                qrisUrl = response.actions?.find((a: any) => a.name === 'generate-qr-code')?.url;
            }

            const trx = await this.prisma.transaction.create({
                data: {
                    id: orderId,
                    userId: req.memberId,
                    offeringId: req.offeringId,
                    amount: offering.price,
                    method: req.method,
                    status: req.method === 'CASH' ? 'SETTLEMENT' : 'PENDING',
                    qrisUrl: qrisUrl,
                },
            });

            if (req.method === 'CASH') {
                if (offering.type === 'PRODUCT') {
                    await this.prisma.offering.update({
                        where: { id: req.offeringId },
                        data: { stock: { decrement: 1 } }
                    });
                } else if (offering.type === 'MEMBERSHIP') {
                    await this.membershipService.activateMembership(req.memberId, undefined, req.offeringId);
                    await this.redis.del(`gym:${user.tenantId}:members`);
                }
                // TODO: MEMBERSHIP akan menambahkan endDate berdasarkan durasi offering, SERVICE akan menambahkan entry baru dengan endDate berdasarkan durasi offering
                await this.redis.del(`gym:${user.tenantId}:offerings`);
            }

            return create(TransactionSchema, sanitizeNull({
                ...trx,
                amount: BigInt(trx.amount.toString()),
                createdAt: timestampFromDate(new Date(trx.createdAt)),
            }));
        }
    }

    @GrpcMethod('TransactionService', 'GetTransactions')
    async getTransactions(req: any, context: any) {
        let user: any;
        let isConnectRpc = false;

        if (context && context.values && typeof context.values.get === 'function') {
            isConnectRpc = true;
            user = context.values.get(kUser);
        } else {
            isConnectRpc = false;
            let metadata: grpc.Metadata | null = context;

            if (metadata && typeof metadata.get === 'function') {
                const authHeader = (metadata.get('authorization')?.[0] || metadata.get('Authorization')?.[0]) as string;
                if (authHeader && authHeader.startsWith('Bearer ')) {
                    const token = authHeader.replace('Bearer ', '').trim();
                    const sessionStr = await this.redis.get(`token:${token}`);
                    if (sessionStr) {
                        user = JSON.parse(sessionStr);
                    }
                }
            }
        }

        if (!user) {
            throw new RpcException({
                code: grpc.status.UNAUTHENTICATED,
                message: 'Akses ditolak! Sesi tidak valid atau telah kedaluwarsa.',
            });
        }

        const adminTenantId = user?.tenantId || user?.user?.tenantId;
        const adminRole = user?.role || user?.user?.role;

        let tenantFilter = {};

        // if (adminRole === 'SUPER_ADMIN') {
        // tenantFilter = {};
        // } else {
        tenantFilter = { user: { tenantId: Number(adminTenantId) } };
        // }

        const transactions = await this.prisma.transaction.findMany({
            where: {
                ...tenantFilter,
                ...(req.startDate && req.endDate && {
                    createdAt: {
                        gte: new Date(req.startDate),
                        lte: new Date(req.endDate),
                    }
                })
            },
            include: {
                user: true,
                plan: true,
                offering: true,
            },
            orderBy: { createdAt: 'desc' }
        });

        const formattedTransactions = transactions.map((trx) => {
            return {
                id: String(trx.id),
                memberId: Number(trx.userId),
                memberName: trx.user?.name || '',
                planId: trx.plan ? Number(trx.plan.id) : undefined,
                planName: trx.plan?.name || '',
                offeringId: trx.offering ? Number(trx.offering.id) : undefined,
                offeringName: trx.offering?.name || '',
                amount: BigInt(trx.amount.toString()),
                method: trx.method || '',
                status: trx.status || '',
                qrisUrl: trx.qrisUrl ?? "",
                createdAt: timestampFromDate(new Date(trx.createdAt)),
            };
        });

        if (isConnectRpc) {
            const connectTransactions = formattedTransactions.map(trx => create(TransactionSchema, sanitizeNull(trx)));
            return { transactions: connectTransactions };
        } else {
            return { transactions: formattedTransactions };
        }
    }

    @GrpcMethod('TransactionService', 'GetFinanceSummary')
    async getFinanceSummary(req: GetTransactionsRequest, context: any) {
        const user = context.values.get(kUser);

        const tenantId = user?.tenantId;
        if (!tenantId) {
            throw new RpcException({
                code: grpc.status.INVALID_ARGUMENT,
                message: 'Tenant ID tidak ditemukan dalam sesi Anda.',
            });
        }

        const cacheKey = `gym:${tenantId}:finance:summary`;

        const cachedData = await this.redis.get(cacheKey);
        if (cachedData) {
            console.log("⚡ [REDIS] Mengambil Summary dari Cache");
            return JSON.parse(cachedData);
        }

        const [totalMember, summary, totalTransactions, activeMemberships] = await Promise.all([
            this.prisma.user.count({
                where: {
                    tenantId: Number(tenantId),
                    role: 'MEMBER'
                },
            }),
            this.prisma.transaction.aggregate({
                where: {
                    user: { tenantId: tenantId },
                    status: 'SETTLEMENT',
                },
                _sum: { amount: true }
            }),
            this.prisma.transaction.count({
                where: {
                    user: { tenantId: tenantId },
                    status: 'SETTLEMENT',
                }
            }),
            this.prisma.membership.count({
                where: {
                    user: { tenantId: tenantId },
                    status: 'ACTIVE',
                }
            })
        ]);

        const result = {
            totalMember: totalMember,
            totalRevenue: summary._sum.amount?.toString() || "0",
            totalTransactions: totalTransactions,
            activeMemberships: activeMemberships
        };

        await this.redis.set(cacheKey, JSON.stringify(result), 'EX', 300);

        return result;
    }
}