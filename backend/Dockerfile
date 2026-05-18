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
WORKDIR /app

COPY backend/package*.json ./
COPY backend/bun.lock ./
RUN bun install --production

COPY --from=builder /app/backend/dist /app/backend/dist
COPY --from=builder /app/backend/prisma /app/backend/prisma
COPY --from=builder /app/gen /app/gen

EXPOSE 50051

CMD ["bun", "run", "-r", "tsconfig-paths/register", "/app/backend/dist/backend/src/main.js"]