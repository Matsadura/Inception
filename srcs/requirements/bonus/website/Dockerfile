FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y nginx gettext-base \
	&& rm -rf /var/lib/apt/lists/*

ARG WEBSITE_PORT
ENV WEBSITE_PORT=${WEBSITE_PORT}

COPY conf/default.conf /etc/nginx/conf.d/default.conf.template
COPY index.html /var/www/html/index.html

EXPOSE ${WEBSITE_PORT}

CMD ["nginx", "-g", "daemon off;"]
