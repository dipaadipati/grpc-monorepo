FROM node:20-alpine AS builder

WORKDIR /app

COPY backend/package*.json ./backend/
COPY backend/prisma ./backend/prisma/

WORKDIR /app/backend
RUN npm install @bufbuild/protobuf
RUN npm install

WORKDIR /app
COPY gen/ ./gen/

COPY backend/ ./backend/

WORKDIR /app/backend
RUN npx prisma generate
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app/backend

COPY backend/package*.json ./
RUN npm install --production

COPY --from=builder /app/backend/dist ./dist
COPY --from=builder /app/backend/prisma ./prisma
COPY --from=builder /app/gen /app/gen

EXPOSE 50051

CMD ["node", "dist/main.js"]