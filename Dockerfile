FROM php:8.2-apache

# Instala extensões do PHP e dependências do sistema
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    libzip-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    mysql-client \
    && docker-php-ext-install pdo_mysql zip

# Instala o Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copia os arquivos da aplicação
COPY . /var/www/html/

# Permissões
RUN chown -R www-data:www-data /var/www/html \
    && a2enmod rewrite

# Define diretório de trabalho
WORKDIR /var/www/html

# Porta padrão do Apache
EXPOSE 80
