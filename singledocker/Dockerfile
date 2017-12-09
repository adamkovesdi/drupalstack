#
# docker file for LAMP stack by adamkov
# tailored for Drupal
#

FROM ubuntu:16.04
MAINTAINER adamkov

# APT package manager update and upgrade
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y vim unzip wget curl

# Install PHP
RUN apt-get install -y \
    php7.0 \
    php7.0-cli \
    php7.0-mbstring \ 
    php7.0-zip \
    php7.0-dom \
    php7.0-curl \
    php7.0-mysql \
    php7.0-gd \
    composer

# Install Apache
RUN apt-get install -y apache2 libapache2-mod-php7.0
RUN a2enmod rewrite

# Install MySQL
RUN echo 'mysql-server mysql-server/root_password password password' | debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password password' | debconf-set-selections
RUN apt-get install -y mysql-client mysql-server

# Copy configurations
WORKDIR /var/www/application
COPY apache.config /etc/apache2/sites-available/000-default.conf
COPY start.sh /usr/bin/

# Copy Drupal tarball
COPY drupal-8.4.3.tar.gz /var/www/application/
# untar
RUN tar xvzf drupal-8.4.3.tar.gz
RUN mv drupal-8.4.3 public
RUN chown -R www-data public

# Publish Apache port
EXPOSE 80
# Publish MySQL port
EXPOSE 3306

# Entrypoint for docker
CMD ["/usr/bin/start.sh"]
