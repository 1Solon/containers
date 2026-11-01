#!/usr/bin/env bash
set -Eeuo pipefail

cd /app
alembic upgrade head
python /scripts/apply-config.py

exec uvicorn main:app \
    --host 0.0.0.0 \
    --port "${MEM0_PORT:-8000}" \
    --proxy-headers \
    --forwarded-allow-ips "*" \
    "$@"
