FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y nginx gettext-base \
	&& rm -rf /var/lib/apt/lists/*

ARG NGINX_PORT
ARG WORDPRESS_PORT
ENV NGINX_PORT=${NGINX_PORT}
ENV WORDPRESS_PORT=${WORDPRESS_PORT}

RUN mkdir -p /var/www/wordpress && \
    chown -R www-data:www-data /var/www/wordpress

COPY conf/default.conf /etc/nginx/conf.d/default.conf.template
COPY tools/ssl.cert /etc/ssl/certs/ssl.cert
COPY tools/ssl.key /etc/ssl/private/ssl.key

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE ${NGINX_PORT}

ENTRYPOINT ["/entrypoint.sh"]
CMD ["nginx", "-g", "daemon off;"]
