# Image backend: Express API, không cần Node_modules của frontend
FROM node:20-alpine
WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY server.js db.js ./

# server.js serve index.html từ thư mục public khi truy cập "/" .
# Thực tế frontend do container frontend đảm nhiệm, đây chỉ là trang
# placeholder để không bị lỗi 500 nếu ai trỏ thẳng vào backend.
RUN mkdir -p public && \
    printf '<!doctype html><meta charset="utf-8"><title>API</title><p>Backend API dang chay.</p>' > public/index.html

ENV PORT=3000
EXPOSE 3000
CMD ["node", "server.js"]
