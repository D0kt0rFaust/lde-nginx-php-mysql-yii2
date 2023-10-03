# Для начала указываем исходный образ, он будет использован как основа
FROM php:8.0-fpm

# Пробрасываем пользователя в контейнер
ARG USER
ARG UID=1000

# Ставим расширения и зависимости
RUN apt-get update && apt-get install -y \
        curl \
        wget \
        git \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
    libpng-dev \
    libonig-dev \
    libzip-dev \
    libmcrypt-dev \
#        && pecl install mcrypt-1.0.3 \
#    && docker-php-ext-enable mcrypt \
        && docker-php-ext-install -j$(nproc) iconv mbstring mysqli pdo_mysql zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
        && docker-php-ext-install -j$(nproc) gd 

RUN useradd -u $UID -G www-data,root -d /home/$USER $USER && echo "$USER:$USER" | chpasswd && adduser $USER sudo
RUN mkdir -p /home/$USER/.composer
RUN chown -R $USER:$USER /home/$USER

# Куда же без composer'а.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Добавим свой php.ini, можем в нем определять свои значения конфига
ADD ../../etc/php/php.ini /usr/local/etc/php/conf.d/40-custom.ini

# Указываем рабочую директорию для PHP
WORKDIR /var/www

USER $USER

CMD ["php-fpm"]