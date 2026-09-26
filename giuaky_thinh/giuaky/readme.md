cách chạy (nhanh — 1 container duy nhất từ Docker Hub):
docker pull thinh1103/giuaky
docker run -d -p 8080:80 --name giuaky thinh1103/giuaky
# Mở: http://localhost:8080

Cách cũ — build + chạy 3 service (db/backend/frontend) trên Docker Desktop:
docker compose up --build -d
# Mở: http://localhost:8080
Hoặc build riêng từng folder:
docker build -t dictionary-db ./db
docker build -t dictionary-backend ./backend
docker build -t dictionary-frontend ./frontend

# Dừng hệ thống:
docker compose down
docker rm -f giuaky   # nếu chạy theo cách 1 container



Xong! Đã tạo image all-in-one thinh1103/giuaky và push lên Docker Hub. Người khác giờ chỉ cần:
docker pull thinh1103/giuaky
docker run -d -p 8080:80 --name giuaky thinh1103/giuaky
Mở http://localhost:8080 là dùng. Container chứa sẵn PostgreSQL (nạp 10 từ), backend Node, và Nginx — đã test chạy thật và API /api/health, /api/words, frontend đều OK.
File mới trong thư mục allinone/:
- Dockerfile — multi-stage build
- nginx.conf — proxy /api/ → 127.0.0.1:3000
- entrypoint.sh — khởi tạo DB lần đầu rồi chạy đồng thời cả 3 dịch vụ