FROM php:8.2-fpm

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    nginx \
    nodejs \
    npm \
    default-mysql-client

# Очистка кеша
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Установка PHP расширений
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Настройка рабочей директории
WORKDIR /var/www/html

# Копирование файлов проекта
COPY . /var/www/html

# Установка зависимостей
RUN composer install --optimize-autoloader --no-dev
RUN npm install
RUN npm run build

# Настройка прав доступа
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
RUN chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Копирование и настройка Nginx конфига
COPY docker/nginx/conf.d/default.prod.conf /etc/nginx/sites-available/default
RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/
RUN rm -f /etc/nginx/sites-enabled/default

# Создание скрипта запуска
RUN echo '#!/bin/sh\n\
\n\
echo "Waiting for MySQL to be ready..."\n\
for i in `seq 1 30`; do\n\
    if mysqladmin ping -h "$MYSQLHOST" -P "$MYSQLPORT" -u "$MYSQLUSER" -p"$MYSQLPASSWORD" --silent; then\n\
        echo "MySQL is ready!"\n\
        break\n\
    fi\n\
    echo "MySQL is unavailable - sleeping"\n\
    sleep 5\n\
done\n\
\n\
echo "Running database migrations..."\n\
php artisan migrate --force\n\
\n\
echo "Caching configurations..."\n\
php artisan config:cache\n\
php artisan route:cache\n\
php artisan view:cache\n\
\n\
echo "Starting Nginx..."\n\
service nginx start\n\
\n\
echo "Starting PHP-FPM..."\n\
php-fpm' > /start.sh

RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]
