FROM php:8.0-fpm

# Пробрасываем пользователя из docker-compose.yml
ARG USER
ARG UID=1000

# Ставим расширения
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
    libssl-dev \
#   && pecl install mcrypt-1.0.3 \
#   && docker-php-ext-enable mcrypt \
    && docker-php-ext-install -j$(nproc) bcmath iconv mbstring mysqli pdo_mysql sockets zip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Установка PHP-расширения для mongodb и redis
RUN pecl install mongodb redis \
    && docker-php-ext-enable mongodb redis

# Проброс системного юзера
RUN useradd -u $UID -G www-data,root -d /home/$USER $USER && echo "$USER:$USER" | chpasswd && adduser $USER sudo
RUN mkdir -p /home/$USER/.composer
RUN chown -R $USER:$USER /home/$USER

# Куда же без composer'а.
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Добавим свой php.ini, можем в нем определять свои значения конфига
ADD ./etc/php/php.ini /usr/local/etc/php/conf.d/40-custom.ini

# Указываем рабочую директорию для PHP
WORKDIR /var/www

USER $USER

# Запускаем контейнер
CMD ["php-fpm"]
