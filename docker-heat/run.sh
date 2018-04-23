#!/bin/bash

# Write the config files
/etc/write_conf.sh

heat-api -v -d &
sleep 5
heat-api-cfn -v -d &
sleep 5
heat-engine -v -d &
# If any process fails, kill the rest.
# This insures the container stops and systemd will restart it.

wait -n
pkill -P $$
