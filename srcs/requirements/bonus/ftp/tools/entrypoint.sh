#!/bin/bash
set -e

sed -i "s/FTP_PORT_PLACEHOLDER/${FTP_PORT}/g" /etc/vsftpd.conf
sed -i "s/PASV_MIN_PORT_PLACEHOLDER/${FTP_PASV_MIN_PORT}/g" /etc/vsftpd.conf
sed -i "s/PASV_MAX_PORT_PLACEHOLDER/${FTP_PASV_MAX_PORT}/g" /etc/vsftpd.conf

if ! id "$FTP_USER" &>/dev/null; then
    adduser --disabled-password --gecos "" --home /var/www/wordpress --shell /bin/bash $FTP_USER
    echo "$FTP_USER:$(cat $FTP_PASSWORD_FILE)" | chpasswd
    usermod -aG www-data $FTP_USER
fi
echo "$FTP_USER" > /etc/vsftpd.userlist

exec "$@"