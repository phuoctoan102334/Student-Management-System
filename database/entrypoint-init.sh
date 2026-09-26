#!/bin/bash
# Khoi tao DB school + bang students trong background, roi chay sqlservr lam PID 1
SQLCMD=""
for p in /opt/mssql-tools18/bin/sqlcmd /opt/mssql-tools/bin/sqlcmd; do
    if [ -x "$p" ]; then SQLCMD="$p"; break; fi
done

init_db() {
    if [ -z "$SQLCMD" ]; then
        echo "[init] sqlcmd not found, skip auto init"
        return 0
    fi
    for i in $(seq 1 60); do
        if "$SQLCMD" -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -Q "SELECT 1" >/dev/null 2>&1; then
            break
        fi
        sleep 2
    done
    "$SQLCMD" -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -Q "IF DB_ID('school') IS NULL CREATE DATABASE school"
    EXISTS=$("$SQLCMD" -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -h -1 -W -Q "SET NOCOUNT ON; IF OBJECT_ID('school.dbo.students','U') IS NULL SELECT 0 ELSE SELECT 1" | tr -d '[:space:]')
    if [ "$EXISTS" = "0" ]; then
        if "$SQLCMD" -S localhost -U sa -P "$MSSQL_SA_PASSWORD" -C -d school -i /opt/mssql-init/database-setup.sql; then
            echo "[init] database school + bang students da tao"
        else
            echo "[init] loi khi tao bang students"
        fi
    else
        echo "[init] bang students da ton tai, bo qua"
    fi
}

init_db &
exec /opt/mssql/bin/sqlservr
