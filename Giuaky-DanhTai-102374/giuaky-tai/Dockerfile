# Stage 1: build frontend React với Vite
FROM node:20-alpine AS frontend-build
WORKDIR /app/frontend
COPY frontend/package.json frontend/package-lock.json ./
RUN npm ci
COPY frontend/ ./
RUN npm run build

# Stage 2: runtime - Express serve file tĩnh đã build
FROM node:20-alpine
WORKDIR /app
COPY backend/package.json backend/package-lock.json ./
RUN npm ci --omit=dev
COPY backend/server.js backend/db.js ./
# server.js đọc thư mục public nằm cạnh nó (__dirname/public)
COPY --from=frontend-build /app/frontend/dist ./public

ENV PORT=3000
EXPOSE 3000
CMD ["node", "server.js"]
