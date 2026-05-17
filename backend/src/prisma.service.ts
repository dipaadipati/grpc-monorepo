import { Injectable, OnModuleInit } from '@nestjs/common';
import { PrismaClient } from '../generated/prisma/client';
import { PrismaPg } from "@prisma/adapter-pg";

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit {
    constructor() {
        const adapter = new PrismaPg({
            connectionString: `${process.env.DATABASE_URL}?pgbouncer=true&connection_limit=10`,
        });

        super({
            adapter
        });
    }

    async onModuleInit() {
        try {
            await this.$connect();
            console.log('✅ Berhasil terhubung ke PostgreSQL di VPS');
        } catch (error) {
            console.error('❌ Gagal koneksi database:', error);
        }
    }
}