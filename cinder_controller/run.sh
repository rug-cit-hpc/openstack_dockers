#!/bin/bash

# Write the config files
/etc/write_conf.sh
# start glance service
cinder-scheduler -d &
sleep 5
apachectl -DFOREGROUND &

tail -f /var/log/apache2/* &
# If any process fails, kill the rest.
# This ensures the container stops and systemd will restart it.

wait -n
pkill -P $$
