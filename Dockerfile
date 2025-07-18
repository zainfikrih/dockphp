# Gunakan base image resmi PHP versi 8.1 dengan FPM
FROM php:8.1-fpm

# Gabungkan semua perintah RUN untuk instalasi ekstensi
# Ini mengurangi jumlah layer pada image Docker, membuatnya lebih efisien
RUN apt-get update && apt-get install -y \
    libzip-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libfreetype6-dev \
    libicu-dev \
    git \
    libpq-dev \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_pgsql \
    && docker-php-ext-install zip \
    && docker-php-ext-install intl \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug

# Instal Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# Instal Node.js dan npm menggunakan NodeSource untuk versi terbaru
# Ini adalah metode yang disarankan untuk mendapatkan Node.js yang stabil dan terbaru di Debian/Ubuntu
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
    && apt-get install -y nodejs

# Atur direktori kerja
WORKDIR /var/www/html

# Peringatan: Pastikan Anda menambahkan file ke dalam image setelah perintah ini
# Misal:
# COPY . .
# RUN composer install
# RUN npm install && npm run build