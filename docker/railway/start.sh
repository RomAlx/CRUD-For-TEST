#!/bin/bash
# docker/railway/start.sh

# Запуск миграций
php artisan migrate --force

# Запуск PHP-FPM
php-fpm -D

# Запуск Nginx
nginx -g "daemon off;"
