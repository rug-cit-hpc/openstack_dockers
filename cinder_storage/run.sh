#!/bin/bash

# Write the config files
/etc/write_conf.sh
# start cinder processes.
tgtd

cinder-volume -d &

# If any process fails, kill the rest.
# This ensures the container stops and systemd will restart it.

wait -n
pkill -P $$
