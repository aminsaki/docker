FROM alpine:3.10

MAINTAINER "aminsaki"

RUN adduser -D -H -g '' -u 9009 myapp

RUN apk --update add \
        php7-mysqli\
        php7-gd \
        php7-xmlreader \
        php7-openssl \
        php7-zlib \
        php7-phar \
        php7-dom \
        php7-ctype \
        php7-curl \
        php7-fpm \
        php7-intl \
        php7-json \
        php7-mbstring \
		php7-mcrypt \
        php7-mysqlnd \
        php7-opcache \
        php7-pdo \
        php7-pdo_mysql \
        php7-posix \
        php7-session \
        php7-tidy \
        php7-xml \
        php7-zip \
        php7-tokenizer \
        php7-bcmath \
        php7-pcntl \
        php7-fileinfo \
        nginx \
        supervisor \
        shadow \
        curl \
        bash \
    && rm -rf /var/cache/apk/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer  | php -- --install-dir=/usr/bin --filename=composer

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


