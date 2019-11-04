FROM php:7.2-apache
RUN requirements="libxslt-dev libldap2-dev libmcrypt-dev libpq-dev libxml2-dev libfreetype6-dev libjpeg62-turbo-dev libpng-dev libtidy-dev unzip git" \
    && apt-get update && apt-get install -y $requirements \
    && docker-php-ext-configure gd --with-jpeg-dir=/usr/lib \
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd


RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu

RUN docker-php-ext-install mbstring \
    xsl \
    intl \
    bcmath \
    calendar \
    exif \
    gettext \
    tidy \
    ldap \
    pcntl \
    posix \
    mysqli

RUN pecl install xdebug-2.6.0

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN apt-get update -y \
  && apt-get install -y \
     libxml2-dev \
  && apt-get clean -y \
  && docker-php-ext-install soap

ADD ./project /var/www/html/project
ADD ./docker/php_config/php-extras.ini /usr/local/etc/php/conf.d/php-extras.ini
ADD ./docker/apache_config/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite

WORKDIR /var/www/html/project

RUN composer i

RUN composer dump -o

EXPOSE 8000