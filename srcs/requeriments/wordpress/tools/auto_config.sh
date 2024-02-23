#!/bin/bash

sleep 10

wp-cli.phar cli update --yes --allow-root
wp-cli.phar core download --allow-root


if [ ! -e /var/www/wordpress/wp-config.php ]; then
    wp-cli.phar config create --allow-root \
        --dbname=$MDB_DATABASE \
        --dbuser=$MDB_USER \
        --dbpass=$MDB_PASSWORD \
        --dbhost=mariadb:3306 \
        --path='/var/www/wordpress'

    sleep 2

    wp-cli.phar core install --allow-root \
    	--url=$DOMAIN_NAME \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --path='/var/www/wordpress'

    wp-cli.phar user create --allow-root \
        --role=author $WP_USERNAME $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --path='/var/www/wordpress'
fi

mkdir -p ./run/php

/usr/sbin/php-fpm7.3 -F
