#!/bin/bash
# start nova compute service

/etc/write_conf.sh

/usr/bin/neutron-linuxbridge-agent --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/linuxbridge_agent.ini -v -d &

/usr/bin/nova-compute --config-file=/etc/nova/nova-compute.conf &

sleep 3
/usr/bin/neutron-dhcp-agent \
--config-file /etc/neutron/neutron.conf \
--config-file /etc/neutron/plugins/ml2/ml2_conf.ini \
--config-file /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
--config-file /etc/neutron/dhcp_agent.ini \
--config-file /etc/neutron/metadata_agent.ini \
--config-dir /etc/neutron/ \
-v -d &

sleep 3
neutron-metadata-agent \
--config-file /etc/neutron/neutron.conf \
--config-file /etc/neutron/plugins/ml2/ml2_conf.ini \
--config-file /etc/neutron/plugins/ml2/linuxbridge_agent.ini \
--config-file /etc/neutron/dhcp_agent.ini \
--config-file /etc/neutron/metadata_agent.ini \
--config-dir /etc/neutron/ \
-v -d &

sleep 3
neutron-l3-agent \
--config-file /etc/neutron/l3_agent.ini \
--config-file /etc/neutron/neutron.conf \
--config-file /etc/neutron/metadata_agent.ini \
--config-dir /etc/neutron/ \
-v -d &

# If any process fails, kill the rest.
# This ensures the container stops and systemd will restart it.

wait -n
pkill -P $$
