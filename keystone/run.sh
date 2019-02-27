#!/bin/bash
# start nova compute service

chown keystone: /etc/keystone/fernet-keys
chmod 700 /etc/keystone/fernet-keys
/etc/write_conf.sh

# Start apache
a2enmod ssl
apachectl -DFOREGROUND &

tail -f /var/log/apache2/* &

chown _shibd: /etc/shibboleth/sp*.pem

shibd -f -F &

# If any process fails, kill the rest.
# This ensures the container stops and systemd will restart it.

wait -n
pkill -P $$

