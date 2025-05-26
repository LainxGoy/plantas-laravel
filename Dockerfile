# Usa una imagen oficial de PHP con Apache y extensiones necesarias
FROM php:8.2-apache

# Instala dependencias del sistema, extensiones de PHP y Composer
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    libpng-dev \
    sqlite3 \
    && docker-php-ext-install pdo pdo_mysql zip

# Instala Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copia los archivos del proyecto al contenedor
COPY . /var/www/html

# Establece el working directory
WORKDIR /var/www/html

# Da permisos a Laravel para escribir en ciertas carpetas
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Expone el puerto por defecto de Apache
EXPOSE 80

# Comando para iniciar Apache
CMD ["apache2-foreground"]
