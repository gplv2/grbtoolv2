#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

[ -r /etc/lsb-release ] && . /etc/lsb-release

if [ -z "$DISTRIB_RELEASE" ] && [ -x /usr/bin/lsb_release ]; then
    # Fall back to using the very slow lsb_release utility
    DISTRIB_RELEASE=$(lsb_release -s -r)
    DISTRIB_CODENAME=$(lsb_release -s -c)
fi

printf "Disable xdebug"

if [ -L /etc/php/7.0/cli/conf.d/20-xdebug.ini ]; then
    printf "Disabling Xdebug for compilation - cli"
    rm -f /etc/php/7.0/cli/conf.d/20-xdebug.ini
fi

if [ -L /etc/php/7.0/fpm/conf.d/20-xdebug.ini ]; then
    printf "Disabling Xdebug for compilation - fpm"
    rm -f /etc/php/7.0/fpm/conf.d/20-xdebug.ini
fi

printf "Installing the geo-api"


echo "Installing SSH deployment keys"
if [ ! -d "/root/.ssh" ]; then 
    mkdir /root/.ssh
    chmod 700 /root/.ssh
fi

cp /vagrant/scripts/deployment_key.rsa /root/.ssh/deployment_key.rsa
cp /vagrant/scripts/deployment_key.rsa.pub /root/.ssh/deployment_key.rsa.pub
cp /vagrant/scripts/ssh_config /root/.ssh/config

chmod 600 /root/.ssh/deployment_key.rsa
chmod 644 /root/.ssh/deployment_key.rsa.pub
chmod 644 /root/.ssh/config

echo "Adding SSH bitbucket host key"

# Create known_hosts
touch /root/.ssh/known_hosts

# Add bitbuckets key
ssh-keyscan bitbucket.org >> /root/.ssh/known_hosts

echo "Cloning code"

cd /var/www
git clone https://github.com/gplv2/grbtool grb-api

echo "Completing installation composers/laravel (as vagrant user)"

chown vagrant:vagrant /var/www
chown -R vagrant:vagrant /var/www/grb-api

sudo su - vagrant -c "cd /var/www/grb-api && composer install --no-progress"
# Make cache dir

sudo su - vagrant -c "cd /var/www/grb-api && mkdir bootstrap/cache"
export DEBIAN_FRONTEND=noninteractive

printf "Setting up the grb-api base database config"

if [ ! -x "/var/www/grb-api/.env" ]; then 
    printf "Verifying postgres DB port"
    #sed -i 's/DB_PORT=5433/DB_PORT=5432/' /var/www/grb-api/.env
fi

echo "Completing installation composers/laravel (as vagrant user)"

printf "Create migration table"
sudo su - vagrant -c "cd /var/www/grb-api && php artisan migrate:install"
printf "Perform migrations"
sudo su - vagrant -c "cd /var/www/grb-api && php artisan migrate"
printf "Vendor publish"
sudo su - vagrant -c "cd /var/www/grb-api && php artisan vendor:publish"
printf "Optimize"
sudo su - vagrant -c "cd /var/www/grb-api && php artisan optimize"
printf "Dump autoload"
sudo su - vagrant -c "cd /var/www/grb-api && composer dump-autoload"

