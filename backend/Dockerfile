FROM oven/bun:alpine AS builder

WORKDIR /app

COPY backend/package*.json ./backend/
COPY backend/bun.lock ./backend/
COPY backend/prisma ./backend/prisma/

WORKDIR /app/backend
RUN bun install @bufbuild/protobuf@2
RUN bun install

WORKDIR /app
COPY gen/ ./gen/
COPY backend/ ./backend/

RUN ln -s /app/backend/node_modules /app/node_modules

WORKDIR /app/backend
RUN bunx prisma generate
RUN bun run build

FROM oven/bun:alpine AS runner
WORKDIR /app/backend

COPY backend/package*.json ./
COPY backend/bun.lock ./
RUN bun install --production

COPY --from=builder /app/backend/dist ./dist
COPY --from=builder /app/backend/prisma ./prisma
COPY --from=builder /app/gen /app/gen
COPY --from=builder /app/node_modules /app/node_modules

EXPOSE 50051

CMD ["bun", "run", "dist/main.js"]