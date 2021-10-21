FROM alpine:edge

WORKDIR /var/www/html/

# Essentials
RUN echo "UTC" > /etc/timezone
RUN apk add --no-cache zip unzip curl sqlite nginx supervisor

# Installing bash
RUN apk add bash
RUN sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd

# Installing PHP
RUN apk add --no-cache php \
    php-common \
    php-fpm \
    php-pdo \
    php-opcache \
    php-zip \
    php-phar \
    php-iconv \
    php-cli \
    php-curl \
    php-openssl \
    php-mbstring \
    php-tokenizer \
    php-fileinfo \
    php-json \
    php-xml \
    php-xmlwriter \
    php-simplexml \
    php-dom \
    php-pdo_mysql \
    php-pdo_sqlite \
    php-tokenizer \
    php7-pecl-redis
    
    
# Installing composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
RUN rm -rf composer-setup.php



# Configure supervisor
RUN mkdir -p /etc/supervisor.d/
COPY ./config/supervisord.ini /etc/supervisor.d/supervisord.ini

# Configure php-fpm
RUN mkdir -p /run/php/
RUN touch /run/php/php7.4-fpm.pid
RUN touch /run/php/php7.4-fpm.sock



RUN mkdir -p /run/nginx && mkdir -p /etc/supervisor.d
RUN mkdir -p /var/www/html

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/fpm-pool.conf /etc/php7/php-fpm.d/www.conf
COPY ./config/supervisord.ini /etc/supervisor.d/supervisord.ini

COPY ./config/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY ./config/gosu-amd64 /usr/local/bin/gosu
RUN chmod +x /usr/local/bin/gosu
RUN chmod +x /usr/local/bin/entrypoint.sh


ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]