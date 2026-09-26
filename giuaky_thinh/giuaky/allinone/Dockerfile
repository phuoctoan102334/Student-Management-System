# Image ALL-IN-ONE: PostgreSQL + Backend + Frontend trong 1 container duy nhất.
# Người dùng chỉ cần: docker run -p 8080:80 thinh1103/giuaky

# Giai đoạn 1: build frontend (React/Vite ra file tĩnh)
FROM node:20-alpine AS build-frontend

WORKDIR /app

COPY frontend/package*.json ./
RUN npm ci

COPY frontend/ ./
RUN npm run build

# Giai đoạn 2: image chung — cài PostgreSQL + Nginx, chép backend + frontend
FROM node:20-alpine

RUN apk add --no-cache postgresql postgresql-contrib nginx

WORKDIR /app

# Backend (Node/Express)
COPY backend/package*.json ./
RUN npm ci --omit=dev
COPY backend/server.js backend/db.js ./
COPY backend/102688 ./102688

# Frontend (file tĩnh) - Nginx phục vụ, Express cũng giữ bản copy để mở thẳng /api
COPY --from=build-frontend /app/dist /usr/share/nginx/html
COPY --from=build-frontend /app/dist ./public
COPY --from=build-frontend /app/102688 ./102688-frontend

# Nginx proxy /api/ sang backend trong cùng container
COPY allinone/nginx.conf /etc/nginx/http.d/default.conf

# Script khởi động 3 dịch vụ trong 1 lệnh
COPY allinone/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV DB_HOST=127.0.0.1 \
    DB_PORT=5432 \
    DB_USER=postgres \
    DB_PASSWORD=postgres \
    DB_NAME=dictionary \
    PORT=3000 \
    PGDATA=/data/pgdata

EXPOSE 80
CMD ["/entrypoint.sh"]