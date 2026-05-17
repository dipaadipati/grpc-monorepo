-- CreateEnum
CREATE TYPE "OfferingType" AS ENUM ('MEMBERSHIP', 'PRODUCT', 'SERVICE');

-- AlterTable
ALTER TABLE "Transaction" ADD COLUMN     "offeringId" INTEGER;

-- CreateTable
CREATE TABLE "Offering" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "price" DECIMAL(65,30) NOT NULL,
    "type" "OfferingType" NOT NULL DEFAULT 'MEMBERSHIP',
    "duration" INTEGER,
    "stock" INTEGER,
    "quota" INTEGER,

    CONSTRAINT "Offering_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_offeringId_fkey" FOREIGN KEY ("offeringId") REFERENCES "Offering"("id") ON DELETE SET NULL ON UPDATE CASCADE;
