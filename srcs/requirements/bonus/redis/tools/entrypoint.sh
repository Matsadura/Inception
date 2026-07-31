#!/bin/sh
set -e

exec redis-server --protected-mode no --port "${REDIS_PORT}" --bind 0.0.0.0