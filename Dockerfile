# Dockerfile

# Base image: PHP 8.2 with Apache
FROM php:8.2-apache

# Instala dependencias del sistema y librerías de desarrollo necesarias
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    sqlite3 \
    default-libmysqlclient-dev \
    libxml2-dev \
    zlib1g-dev && \
    docker-php-ext-install pdo pdo_mysql zip mbstring exif pcntl bcmath xml

# Habilita módulos de Apache
RUN a2enmod rewrite headers

# Copia Composer desde la imagen oficial
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Establece el directorio de trabajo
WORKDIR /var/www/html

# Copia los archivos del proyecto
COPY . /var/www/html

# Prepara el entorno de Laravel: copia .env y crea base SQLite
RUN cp .env.example .env && mkdir -p database && touch database/database.sqlite

# Variables de entorno para Laravel
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/var/www/html/database/database.sqlite

# Instala dependencias, genera key, migra y seed
RUN composer install --no-dev --optimize-autoloader && \
    php artisan key:generate && \
    php artisan migrate --force && \
    php artisan db:seed --force

# Configura Apache para usar la carpeta public de Laravel
env APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e "s!DocumentRoot /var/www/html!DocumentRoot ${APACHE_DOCUMENT_ROOT}!" /etc/apache2/sites-available/000-default.conf

# Ajusta permisos
RUN chown -R www-data:www-data /var/www/html && chmod -R 755 /var/www/html

# Expone el puerto 80
EXPOSE 80

# Arranca Apache en primer plano
CMD ["apache2-foreground"]

