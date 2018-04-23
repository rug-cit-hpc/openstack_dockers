#!/bin/bash

# Write the config files
/etc/write_conf.sh
# start glance service
glance-registry -v -d &
sleep 5
glance-api -v -d &

# If any process fails, kill the rest.
# This insures the container stops and systemd will restart it.

wait -n
pkill -P $$
