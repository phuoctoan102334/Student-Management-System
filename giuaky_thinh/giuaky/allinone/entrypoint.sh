#!/bin/sh
set -e

PORT=${PORT:-3000}
DB_PORT=${DB_PORT:-5432}
DB_NAME=${DB_NAME:-dictionary}
PGDATA=${PGDATA:-/data/pgdata}

cat > /tmp/init.sql <<'SQL'
CREATE TABLE IF NOT EXISTS words (
  id         SERIAL PRIMARY KEY,
  word       VARCHAR(100) NOT NULL UNIQUE,
  definition TEXT         NOT NULL
);

INSERT INTO words (word, definition) VALUES
  ('apple',    'quả táo'),
  ('book',     'quyển sách'),
  ('computer', 'máy tính'),
  ('dog',      'con chó'),
  ('elephant', 'con voi'),
  ('flower',   'bông hoa'),
  ('guitar',   'đàn guitar'),
  ('house',    'ngôi nhà'),
  ('internet', 'mạng internet'),
  ('juice',    'nước ép')
ON CONFLICT (word) DO NOTHING;
SQL

mkdir -p /run/postgresql
chown postgres:postgres /run/postgresql

stop_all() {
  echo "[stop] Đang dừng dịch vụ..."
  [ -n "$BACKEND_PID" ] && kill "$BACKEND_PID" 2>/dev/null || true
  nginx -s stop 2>/dev/null || true
  su postgres -c "pg_ctl -D $PGDATA stop -m fast" >/dev/null 2>&1 || true
  exit 0
}
trap 'stop_all' INT TERM

echo "[db] Khởi động PostgreSQL..."
if [ ! -f "$PGDATA/PG_VERSION" ]; then
  mkdir -p "$PGDATA"
  chown postgres:postgres "$PGDATA"
  echo "[db] Khởi tạo dữ liệu lần đầu..."
  su postgres -c "initdb -D $PGDATA -U postgres --auth=trust" >/dev/null
fi
su postgres -c "pg_ctl -D $PGDATA -o '-p $DB_PORT -c listen_addresses=127.0.0.1' -l /tmp/pg.log start"

until su postgres -c "pg_isready -h 127.0.0.1 -p $DB_PORT -U postgres" >/dev/null 2>&1; do
  sleep 1
done

if ! su postgres -c "psql -h 127.0.0.1 -p $DB_PORT -U postgres -lqt" | cut -d '|' -f 1 | grep -qw "$DB_NAME"; then
  echo "[db] Tạo database $DB_NAME và nạp dữ liệu..."
  su postgres -c "psql -h 127.0.0.1 -p $DB_PORT -U postgres -c 'CREATE DATABASE $DB_NAME'"
  su postgres -c "psql -h 127.0.0.1 -p $DB_PORT -U postgres -d $DB_NAME" < /tmp/init.sql
fi

echo "[app] Khởi động backend (port $PORT)..."
node /app/server.js &
BACKEND_PID=$!

echo "[web] Khởi động Nginx (port 80)..."
nginx -g 'daemon off;' &

echo "[ok] Mọi dịch vụ đã chạy trong container."
wait