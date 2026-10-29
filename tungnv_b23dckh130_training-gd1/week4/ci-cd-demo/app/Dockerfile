FROM node:20-alpine AS deps
WORKDIR /app
COPY package*.json ./
RUN mkdir -p /app/node_modules && if [ -f package-lock.json ]; then npm ci --omit=dev; else npm install --omit=dev; fi

FROM node:20-alpine
ENV NODE_ENV=production
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY package*.json ./
COPY backend/ ./backend/
COPY frontend/ ./frontend/
USER node
EXPOSE 3000
HEALTHCHECK --interval=10s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -q -O - http://127.0.0.1:3000/healthz >/dev/null || exit 1
CMD ["node", "backend/server.js"]
