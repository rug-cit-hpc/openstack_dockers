#!/bin/bash
# start nova service

# write the configuration files with values from the environment.
/etc/write_conf.sh

nova-api -v -d &
sleep 3
nova-consoleauth -v -d &
sleep 3
nova-scheduler -v -d &
sleep 3
nova-conductor -v -d &
sleep 3
nova-novncproxy -v -d &
# start the placement api
apachectl -DFOREGROUND &

# If any process fails, kill the rest.
# This insures the container stops and systemd will restart it.

wait -n
pkill -P $$
