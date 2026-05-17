/*
  Warnings:

  - You are about to drop the column `snapToken` on the `Transaction` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Transaction" DROP COLUMN "snapToken",
ADD COLUMN     "qris_url" TEXT;
