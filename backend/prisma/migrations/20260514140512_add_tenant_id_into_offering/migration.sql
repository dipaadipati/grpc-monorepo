/*
  Warnings:

  - Added the required column `tenantId` to the `Offering` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "Offering" ADD COLUMN     "tenantId" INTEGER NOT NULL;

-- AddForeignKey
ALTER TABLE "Offering" ADD CONSTRAINT "Offering_tenantId_fkey" FOREIGN KEY ("tenantId") REFERENCES "Tenant"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
