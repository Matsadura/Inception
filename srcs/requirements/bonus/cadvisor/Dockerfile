FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y wget ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/google/cadvisor/releases/download/v0.56.2/cadvisor-v0.56.2-linux-amd64 -O /usr/local/bin/cadvisor

RUN chmod +x /usr/local/bin/cadvisor

ARG CADVISOR_PORT
ENV CADVISOR_PORT=${CADVISOR_PORT}

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE ${CADVISOR_PORT}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]