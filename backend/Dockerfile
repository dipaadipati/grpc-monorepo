FROM oven/bun:alpine AS builder

WORKDIR /app

COPY backend/package*.json ./
COPY backend/bun.lock ./
RUN bun install

COPY proto /proto
COPY backend/ ./
RUN bunx prisma generate
RUN bun run build

FROM oven/bun:alpine AS runner

WORKDIR /app

COPY backend/package*.json ./
COPY backend/bun.lock ./
RUN bun install --production

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/generated ./generated

COPY --from=builder /proto /proto

COPY backend/prisma ./prisma
COPY backend/prisma.config.ts ./prisma.config.ts

RUN mkdir -p /app/node_modules \
    && ln -s /app/dist/app/src /app/node_modules/@

EXPOSE 3000
EXPOSE 50051

CMD ["bun", "run", "/app/dist/app/src/main.js"]