#!/bin/bash
set -e

if ! id "$FTP_USER" &>/dev/null; then
    adduser --disabled-password --gecos "" --home /var/www/wordpress --shell /bin/bash $FTP_USER
    echo "$FTP_USER:$(cat $FTP_PASSWORD_FILE)" | chpasswd
    usermod -aG www-data $FTP_USER
fi
echo "$FTP_USER" > /etc/vsftpd.userlist

exec "$@"