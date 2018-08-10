#!/bin/bash
# start nova compute service

chown keystone: /etc/keystone/fernet-keys
chmod 700 /etc/keystone/fernet-keys

# Start apache
a2enmod ssl
apachectl -DFOREGROUND &

chown _shibd: /etc/shibboleth/sp*.pem

shibd -f -F &

# If any process fails, kill the rest.
# This insures the container stops and systemd will restart it.

wait -n
pkill -P $$

