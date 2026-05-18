FROM oven/bun:1.1-alpine AS builder

WORKDIR /app

COPY backend/package*.json ./backend/
COPY backend/bun.lock ./backend/
COPY backend/prisma ./backend/prisma/

WORKDIR /app/backend
RUN bun install @bufbuild/protobuf@1
RUN bun install

WORKDIR /app
COPY gen/ ./gen/
COPY backend/ ./backend/

WORKDIR /app/backend
RUN bunx prisma generate
RUN bun run build

FROM oven/bun:1.1-alpine AS runner
WORKDIR /app/backend

COPY backend/package*.json ./
COPY backend/bun.lock ./
RUN bun install --production

COPY --from=builder /app/backend/dist ./dist
COPY --from=builder /app/backend/prisma ./prisma
COPY --from=builder /app/gen /app/gen

EXPOSE 50051

CMD ["bun", "run", "dist/main.js"]