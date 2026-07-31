FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    vsftpd \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/vsftpd/empty

ARG FTP_PORT
ENV FTP_PORT=${FTP_PORT}
ARG FTP_PASV_MIN_PORT
ENV FTP_PASV_MIN_PORT=${FTP_PASV_MIN_PORT}
ARG FTP_PASV_MAX_PORT
ENV FTP_PASV_MAX_PORT=${FTP_PASV_MAX_PORT}

COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE ${FTP_PORT} ${FTP_PASV_MIN_PORT}-${FTP_PASV_MAX_PORT}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["vsftpd", "/etc/vsftpd.conf"]