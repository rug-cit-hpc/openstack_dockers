#!/bin/bash
# start nova compute service

chown keystone: /etc/keystone/fernet-keys
chmod 700 /etc/keystone/fernet-keys

cat << EOF > /etc/keystone/keystone.conf
[DEFAULT]

verbose = true

[database]
connection = mysql+pymysql://keystone:$KEYSTONE_PASSWORD@mariadb/keystone

[token]
provider = fernet

[identity]
default_domain_id = default
EOF

# Start apache
a2enmod ssl
apachectl -DFOREGROUND &

tail -f /var/log/apache2/* &

wait -n
pkill -P $$
