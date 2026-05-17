import { PrismaClient, Role } from '../generated/prisma/client';
import { PrismaPg } from "@prisma/adapter-pg";
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient({
    adapter: new PrismaPg({ connectionString: process.env.DATABASE_URL })
})

async function main() {
    // await prisma.user.deleteMany();
    // await prisma.tenant.deleteMany();

    const mainTenant = await prisma.tenant.upsert({
        where: { slug: 'hq-gym' },
        update: {},
        create: {
            name: 'HQ Gym Center',
            slug: 'hq-gym',
            address: 'Main Street No. 1',
            isActive: true,
        },
    });

    const hashedPassword = await bcrypt.hash('admin123', 10);

    const superAdmin = await prisma.user.upsert({
        where: { email: 'admin@gym.com' },
        update: {},
        create: {
            email: 'admin@gym.com',
            password: hashedPassword,
            name: 'Super Admin',
            role: Role.SUPER_ADMIN,
            tenantId: mainTenant.id,
        },
    });

    console.log({ mainTenant, superAdmin });
}

main()
    .then(async () => {
        await prisma.$disconnect();
    })
    .catch(async (e) => {
        console.error(e);
        await prisma.$disconnect();
        process.exit(1);
    });