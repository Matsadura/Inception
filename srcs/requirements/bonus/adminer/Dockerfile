FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    wget \
    php \
    php-mysql \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

RUN wget https://github.com/vrana/adminer/releases/download/v5.4.1/adminer-5.4.1.php -O index.php

COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ARG ADMINER_PORT
ENV ADMINER_PORT=${ADMINER_PORT}

EXPOSE ${ADMINER_PORT}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]