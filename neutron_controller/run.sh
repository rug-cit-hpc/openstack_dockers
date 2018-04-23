#!/bin/bash
# start neutron services

/etc/write_conf.sh

/usr/bin/neutron-server \
--config-file /etc/neutron/neutron.conf \
--config-file /etc/neutron/plugins/ml2/ml2_conf.ini \
--config-file /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
--config-file /etc/neutron/metadata_agent.ini \
--config-dir /etc/neutron/ \
-v -d &

sleep 3
/usr/bin/neutron-linuxbridge-agent \
--config-file /etc/neutron/neutron.conf \
--config-file /etc/neutron/plugins/ml2/ml2_conf.ini \
--config-file /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
--config-file /etc/neutron/metadata_agent.ini \
--config-dir /etc/neutron/ \
-v -d &

sleep 3
neutron-metadata-agent \
--config-file /etc/neutron/neutron.conf \
--config-file /etc/neutron/plugins/ml2/ml2_conf.ini \
--config-file /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
--config-file /etc/neutron/metadata_agent.ini \
--config-dir /etc/neutron/ \
-v -d &

# If any process fails, kill the rest.
# This ensures the container stops and systemd will restart it.

wait -n
pkill -P $$
