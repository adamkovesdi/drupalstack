#!/bin/bash

# start mysql
echo "Starting MySQL"
mkdir /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
mysqld_safe &

# start apache in non daemon mode
echo "Starting Apache"
exec /usr/sbin/apache2ctl -D FOREGROUND
