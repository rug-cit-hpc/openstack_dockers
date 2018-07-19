#!/bin/bash
#
# Generate config files from environments values.
# These are to be passed to the docker container using -e

cat << EOF > /etc/neutron/neutron.conf

[DEFAULT]
core_plugin = ml2
service_plugins = router
allow_overlapping_ips = True
transport_url = rabbit://$RABBIT_USER:$RABBIT_PASSWORD@$MY_IP
auth_strategy = keystone
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true
dhcp_agents_per_network = 2

[agent]
root_helper = sudo /usr/bin/neutron-rootwrap /etc/neutron/rootwrap.conf

[database]
connection = mysql+pymysql://$NEUTRON_USER:$NEUTRON_PASSWORD@mariadb/neutron

[keystone_authtoken]
auth_uri = http://$KEYSTONE_HOST:5000
auth_url = http://$KEYSTONE_HOST:35357
memcached_servers = $MEMCACHED_HOST:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = $NEUTRON_USER
password = $NEUTRON_PASSWORD

[nova]
auth_url = http://$KEYSTONE_HOST:35357
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = $NOVA_USER
password = $NOVA_PASSWORD

EOF

cat << EOF > /etc/neutron/plugins/ml2/ml2_conf.ini

[ml2]
type_drivers = flat,vlan,vxlan
tenant_network_types = vxlan
mechanism_drivers = linuxbridge,l2population
extension_drivers = port_security

[ml2_type_vlan]
network_vlan_ranges = provider

[ml2_type_flat]
flat_networks = provider

[ml2_type_vxlan]
vni_ranges = 1:1000

[securitygroup]
enable_ipset = true

EOF

cat << EOF > /etc/neutron/metadata_agent.ini

[DEFAULT]
nova_metadata_ip = $MY_IP
metadata_proxy_shared_secret = $METADATA_SECRET

EOF


cat << EOF > /etc/neutron/plugins/ml2/linuxbridge_agent.ini

[linux_bridge]
physical_interface_mappings = $PHYSICAL_INTERFACE_MAPPINGS

[vxlan]
enable_vxlan = True
l2_population = True
local_ip = $OVERLAY_IP

[securitygroup]
enable_security_group = true
firewall_driver = iptables

EOF

cat << EOF > /etc/neutron/l3_agent.ini

[DEFAULT]
interface_driver = linuxbridge
external_network_bridge =

EOF
