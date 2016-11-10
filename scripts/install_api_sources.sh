#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive

printf "Installing the geo-api"

[ -r /etc/lsb-release ] && . /etc/lsb-release

if [ -z "$DISTRIB_RELEASE" ] && [ -x /usr/bin/lsb_release ]; then
    # Fall back to using the very slow lsb_release utility
    DISTRIB_RELEASE=$(lsb_release -s -r)
    DISTRIB_CODENAME=$(lsb_release -s -c)
fi
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

