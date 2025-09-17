# Use official PHP Apache image
FROM php:8.1-apache

# Install required PHP extensions and dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mysqli pdo pdo_mysql zip

# Enable Apache mod_rewrite
RUN a2enmod rewrite

# Set working directory
WORKDIR /var/www/html

# Download Gibbon release (latest stable from GitHub)
RUN curl -L https://github.com/GibbonEdu/core/archive/refs/tags/v27.0.01.zip -o gibbon.zip \
    && unzip gibbon.zip \
    && mv core-*/* . \
    && rm -rf gibbon.zip core-*

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Expose port 80
EXPOSE 8080

# Run Apache in foreground
CMD ["apache2-foreground"]
