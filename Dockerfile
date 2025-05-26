# Dockerfile

# Usar imagen PHP con Apache
FROM php:8.2-apache

# Instala dependencias del sistema y extensiones de PHP
RUN apt-get update && apt-get install -y \
    libzip-dev unzip git curl sqlite3 \
    && docker-php-ext-install zip pdo pdo_mysql

# Habilita mod_rewrite de Apache
RUN a2enmod rewrite

# Copia composer desde la imagen oficial de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copia todo el proyecto al contenedor
COPY . /var/www/html

# Establece el directorio de trabajo
WORKDIR /var/www/html

# Instala dependencias de PHP con Composer y configura Laravel
RUN composer install --no-dev --optimize-autoloader \
    && php artisan key:generate \
    && php artisan migrate --force \
    && php artisan db:seed --force

# Cambia el DocumentRoot de Apache al directorio public de Laravel
env APACHE_DOCUMENT_ROOT /var/www/html/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf

# Ajusta permisos\RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expone el puerto 80 para el servicio web
EXPOSE 80

# Comando por defecto para iniciar Apache
entrypoint ["docker-php-entrypoint"]
CMD ["apache2-foreground"]
