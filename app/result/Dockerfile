FROM node:18-slim AS builder

WORKDIR /app

COPY package*.json .

RUN npm ci && npm cache clean --force


FROM node:18-slim AS runtime

WORKDIR /app

RUN useradd --no-create-home --shell /bin/false appuser

COPY --from=builder /app/node_modules ./node_modules

COPY . .

RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 80

CMD ["node", "server.js"]