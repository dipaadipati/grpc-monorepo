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

RUN mkdir -p /app/node_modules \
    && ln -s /app/dist/app/src /app/node_modules/@

EXPOSE 50051

CMD ["bun", "run", "/app/dist/app/src/main.js"]