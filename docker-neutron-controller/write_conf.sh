#!/bin/bash
#
# Generate config files from environments values.
# These are to be passed to the docker container using -e

cat << EOF > /etc/neutron/neutron.conf
[DEFAULT]
core_plugin = ml2
service_plugins =
transport_url = rabbit://$RABBIT_USER:$RABBIT_PASSWORD@$MY_IP
auth_strategy = keystone
notify_nova_on_port_status_changes = true
notify_nova_on_port_data_changes = true
dhcp_agents_per_network = 2
global_physnet_mtu = $GLOBAL_PHYSNET_MTU

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
type_drivers = flat,vlan
tenant_network_types =
mechanism_drivers = linuxbridge
extension_drivers = port_security
path_mtu = $GLOBAL_PHYSNET_MTU

[ml2_type_vlan]
network_vlan_ranges = provider

[ml2_type_flat]
flat_networks = provider

[securitygroup]
enable_ipset = true

EOF

cat << EOF > /etc/neutron/plugins/ml2/linuxbridge_agent.ini

[linux_bridge]
physical_interface_mappings = $PHYSICAL_INTERFACE_MAPPINGS

[vxlan]
enable_vxlan = false

[securitygroup]
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

EOF

cat << EOF > /etc/neutron/metadata_agent.ini

[DEFAULT]
nova_metadata_ip = $MY_IP
metadata_proxy_shared_secret = $METADATA_SECRET

EOF
