FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    redis-server \
    && rm -rf /var/lib/apt/lists/*

ARG REDIS_PORT
ENV REDIS_PORT=${REDIS_PORT}

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE ${REDIS_PORT}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
