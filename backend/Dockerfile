FROM node:20-alpine AS builder

WORKDIR /app

COPY backend/package*.json ./
COPY backend/prisma ./prisma/

RUN npm install

COPY gen/ ./gen/

COPY backend/ .

RUN mkdir -p gen && cp -r /app/gen/* ./gen/

RUN npx prisma generate
RUN npm run build

FROM node:20-alpine AS runner
WORKDIR /app

COPY backend/package*.json ./
RUN npm install --production

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/prisma ./prisma
COPY --from=builder /app/gen ./gen 

EXPOSE 50051

CMD ["node", "dist/main.js"]