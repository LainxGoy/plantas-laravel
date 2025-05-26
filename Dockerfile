# Dockerfile

# Base image: PHP 8.2 with Apache
FROM php:8.2-apache

# Install system dependencies and PHP extensions required by Laravel
RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    sqlite3 \
    && docker-php-ext-install \
    pdo \
    pdo_mysql \
    zip \
    mbstring \
    exif \
    pcntl \
    bcmath \
    xml

# Enable Apache modules
RUN a2enmod rewrite headers

# Copy Composer from the official Composer image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy project files
COPY . /var/www/html

# Prepare environment: copy example env and create SQLite database
RUN cp .env.example .env \
    && mkdir -p database \
    && touch database/database.sqlite

# Set environment variables for Laravel
ENV APP_ENV=production
ENV APP_DEBUG=false
ENV DB_CONNECTION=sqlite
ENV DB_DATABASE=/var/www/html/database/database.sqlite

# Install PHP dependencies, generate app key, run migrations and seeders
RUN composer install --no-dev --optimize-autoloader && \
    php artisan key:generate && \
    php artisan migrate --force && \
    php artisan db:seed --force

# Configure Apache to serve from the public directory
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public
RUN sed -ri -e "s!DocumentRoot /var/www/html!DocumentRoot ${APACHE_DOCUMENT_ROOT}!" /etc/apache2/sites-available/000-default.conf

# Adjust permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 80

# Start Apache in foreground
CMD ["apache2-foreground"]
