#!/usr/bin/env bash
DB=$1;
USER=$2;

if [ ! -x "/etc/postgresql/9.5/main/postgresql.conf" ]; then
    printf "Enable listening on all interfaces"
    sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/9.5/main/postgresql.conf
fi

SUBNET=10.0.2.2/32
if [ ! -x "/etc/postgresql/9.5/main/pg_hba.conf" ]; then
    echo "host    all             all             $SUBNET           trust" >> /etc/postgresql/9.5/main/pg_hba.conf
fi

echo "(re)Start postgres db ..."
    /etc/init.d/postgresql restart
    # service postgresql restart # Gives no output, so take old school one

echo "Preparing Database ... $1 / $2 "

sleep 2

# su postgres -c "dropdb $DB --if-exists"

if ! su - postgres -c "psql -d $DB -c '\q' 2>/dev/null"; then
    su - postgres -c "createuser $USER"
    su - postgres -c "createdb --encoding='utf-8' --owner=$USER '$DB'"
fi

echo "Changing user password ..."
cat > /home/vagrant/install.postcreate.sql << EOF
ALTER USER "$USER" WITH PASSWORD 'Berkensap11';
EOF

su - postgres -c "cat /home/vagrant/install.postcreate.sql | psql -d $DB"

