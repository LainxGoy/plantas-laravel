# Dockerfile

# Usa imagen oficial de PHP con Apache
FROM php:8.2-apache

# Instala dependencias del sistema y extensiones de PHP necesarias
RUN apt-get update && apt-get install -y \
    libzip-dev unzip git curl sqlite3 \
    && docker-php-ext-install zip pdo pdo_mysql

# Habilita mod_rewrite en Apache
RUN a2enmod rewrite

# Copia Composer desde la imagen oficial de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copia todos los archivos del proyecto al contenedor
COPY . /var/www/html

# Establece el directorio de trabajo
WORKDIR /var/www/html

# Prepara entorno Laravel: copia .env, genera archivo SQLite
RUN cp .env.example .env \
    && mkdir -p database \
    && touch database/database.sqlite

# Variables de entorno para SQLite
ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/var/www/html/database/database.sqlite
ENV APP_ENV=production
ENV APP_DEBUG=false

# Instala dependencias de PHP, genera key, migra y hace seed de la base
RUN composer install --no-dev --optimize-autoloader && \
    php artisan key:generate && \
    php artisan migrate --force && \
    php artisan db:seed --force

# Configura Apache para usar el directorio public de Laravel como DocumentRoot
ENV APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e "s!DocumentRoot /var/www/html!DocumentRoot ${APACHE_DOCUMENT_ROOT}!" /etc/apache2/sites-available/000-default.conf

# Ajusta permisos para que Apache pueda escribir
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Expone el puerto 80
EXPOSE 80

# Arranca Apache en primer plano
CMD ["apache2-foreground"]
