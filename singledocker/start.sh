#!/bin/bash

# start mysql
mkdir /var/run/mysqld
mysqld_safe &

# start apache in non daemon mode
exec /usr/sbin/apache2ctl -D FOREGROUND

echo "Server started."
