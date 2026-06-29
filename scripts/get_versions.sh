#!/usr/bin/env bash

export PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin'

set -e pipefail

HOSTNAME=$(hostname)

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

if command_exists php; then
	PHP_VERSION=$(php --version | head -n1 | awk '{print $2}' | cut -d'-' -f1)
else
 	PHP_VERSION="not found"
fi

if command_exists php-fpm; then
	PHPFPM_VERSISON=$(php-fpm --version  | head -n1 | cut -d' ' -f2 | cut -d'-' -f1)
elif command_exists php-fpm7.0; then
	PHPFPM_VERSISON=$(php-fpm7.0 --version  | head -n1 | cut -d' ' -f2 | cut -d'-' -f1)
else
	PHPFPM_VERSION="not found"
fi


if command_exists apache2; then
	APACHE_VERSION=$(apache2 -v | awk -F'/' '{print $2}' | awk '{print $1}')
else
	APACHE_VERSION="not found"
fi


if command_exists nginx; then
	NGINX_VERSION=$(nginx -v 2>&1 | awk -F'/' '{print $2}')
else
	NGINX_VERSION="not found"
fi


if command_exists openssl; then
	OPENSSL_VERSION=$(openssl version | cut -d' ' -f2)
else
	OPENSSL_VERSION="not found"
fi


if command_exists python3; then
	PYTHON_VERSION=$(python3 --version | cut -d' ' -f2)
else
	PYTHON_VERSION="not found"
fi


if command_exists npm; then
	NPM_VERSION=$(npm --version)
else
	NPM_VERSION="not found"
fi


cat <<EOF
{
  "hostname": "$HOSTNAME",
  "packages": {
  "php": "$PHP_VERSION",
  "php-fpm": "$PHPFPM_VERSISON",
  "apache": "$APACHE_VERSION",
  "nginx": "$NGINX_VERSION",
  "openssl": "$OPENSSL_VERSION",
  "python": "$PYTHON_VERSION",
  "npm": "$NPM_VERSION" 
}
}
EOF

