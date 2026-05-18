FROM oven/bun:alpine AS builder

WORKDIR /app

COPY backend/package*.json ./
COPY backend/bun.lock ./
COPY backend/prisma ./prisma/

RUN bun install

COPY backend/ ./

RUN bunx prisma generate

RUN bun run build

FROM oven/bun:alpine AS runner

WORKDIR /app

COPY backend/package*.json ./
COPY backend/bun.lock ./

RUN bun install --production

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma

EXPOSE 50051

CMD ["bun", "run", "/app/backend/dist/backend/src/main.js"]