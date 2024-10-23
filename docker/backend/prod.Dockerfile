# docker/backend/Dockerfile.prod
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
    npm

# Очистка кеша
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Установка PHP расширений
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Установка Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Установка рабочей директории
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
COPY docker/nginx/conf.d/default.prod.conf /etc/nginx/conf.d/default.conf
RUN rm /etc/nginx/sites-enabled/default
RUN ln -s /etc/nginx/conf.d/default.conf /etc/nginx/sites-enabled/default

# Создание скрипта запуска для Railway
RUN echo '#!/bin/sh\n\
php artisan config:cache\n\
php artisan route:cache\n\
php artisan view:cache\n\
php artisan migrate --force\n\
service nginx start\n\
php-fpm' > /start.sh

RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]
