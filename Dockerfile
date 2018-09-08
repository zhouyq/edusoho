FROM php:5.6.37-apache-stretch

ENV EDU_VER="8.3.1"

RUN set -ex \
    && sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list \
    && curl http://download.edusoho.com/edusoho-${EDU_VER}.tar.gz | tar xzm -C /var/www/html/ \
    && chown www-data:www-data /var/www/html/ -R \
    && apt-get update \
    && apt-get install -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev libmcrypt-dev libicu-dev libapache2-mod-xsendfile\
    && docker-php-ext-install -j$(nproc) iconv \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure  mcrypt \
    && docker-php-ext-install -j$(nproc) mcrypt \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-enable opcache

COPY edusoho.conf /etc/apache2/sites-available/000-default.conf
COPY docker-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /var/www/html

EXPOSE 80

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["apache2-foreground"]