#!/bin/bash

sed -i "s/user\ \=.*/user\ \= $WWWUSERID/g" /etc/php7/php-fpm.d/www.conf

usermod -u $WWWUSERID myapp

if [ $# -gt 0 ];then
    exec /usr/local/bin/gosu $WWWUSERID "$@"
else
     /usr/bin/supervisord
fi

if [ ! -d /.composer ]; then
    mkdir /.composer
fi
chmod -R ugo+rw /.composer



