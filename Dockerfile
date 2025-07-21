
# Usa uma imagem oficial do PHP com Apache
FROM php:8.2-apache

# Instala extensões do PHP necessárias para o Laravel e o BookStack
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    libzip-dev \
    mariadb-client \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Habilita o mod_rewrite do Apache (essencial para Laravel)
RUN a2enmod rewrite

# Instala o Composer (gerenciador de dependências do PHP)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Define o diretório de trabalho
WORKDIR /var/www/html

# Copia os arquivos da aplicação para o container
COPY . .

# Instala dependências PHP via Composer
RUN composer install --no-dev --optimize-autoloader

# Define permissões corretas (Laravel precisa gravar em storage e bootstrap/cache)
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# Gera cache de configuração
RUN php artisan config:cache

# Expõe a porta padrão do Apache
EXPOSE 80

# Inicia o Apache ao rodar o container
CMD ["apache2-foreground"]
