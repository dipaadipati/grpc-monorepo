/*
  Warnings:

  - You are about to drop the column `qris_url` on the `Transaction` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "Transaction" DROP COLUMN "qris_url",
ADD COLUMN     "qrisUrl" TEXT;
