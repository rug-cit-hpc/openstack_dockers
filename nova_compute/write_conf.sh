#!/bin/bash
#
# Generate config files from environments values.
# These are to be passed to the docker container using -e

cat << EOF > /root/admin-openrc.sh
#!/bin/bash
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=${OS_PASSWORD}
export OS_AUTH_URL=https://merlin.hpc.rug.nl:35357/v3
export OS_IDENTITY_API_VERSION=3

export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_IMAGE_API_VERSION=2

EOF

cat << EOF > /etc/nova/nova.conf

[DEFAULT]
transport_url = rabbit://$RABBIT_USER:$RABBIT_PASSWORD@$RABBIT_HOST
rabbit_host = $RABBIT_HOST
dhcpbridge_flagfile=/etc/nova/nova.conf
dhcpbridge=/usr/bin/nova-dhcpbridge
force_dhcp_release=true
state_path=/var/lib/nova
enabled_apis=osapi_compute,metadata
service_metadata_proxy = True
metadata_proxy_shared_secret = $METADATA_SECRET
my_ip = $MY_IP
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver
scheduler_default_filters = AllHostsFilter
allow_migrate_to_same_host = True
allow_resize_to_same_host = True
security_group_api=neutron


[neutron]
url = http://$NEUTRON_CONTROLLER_HOST:9696
auth_url = https://$KEYSTONE_HOST:35357
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = $NEUTRON_USER
password = $NEUTRON_PASSWORD


[glance]
api_servers = http://$GLANCE_CONTROLLER_HOST:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp

[api]
auth_strategy = keystone

[keystone_authtoken]
auth_uri = https://$KEYSTONE_HOST:5000
auth_url = https://$KEYSTONE_HOST:35357
memcached_servers = $MEMCACHED_HOST:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = $NOVA_USER
password = $NOVA_PASSWORD

[api_database]
connection = mysql+pymysql://$NOVA_COMPUTE_USER:$NOVA_PASSWORD@mariadb/nova_api

[barbican]
[cache]

[cells]
enable=False

[placement]
os_region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = https://$KEYSTONE_HOST:35357/v3
username = $NOVA_PLACEMENT_USER
password = $NOVA_PLACEMENT_PASSWORD

[cinder]
os_region_name = RegionOne

[wsgi]
api_paste_config=/etc/nova/api-paste.ini

EOF


cat << EOF > /etc/nova/nova-compute.conf
[DEFAULT]
compute_driver=libvirt.LibvirtDriver
transport_url = rabbit://$RABBIT_USER:$RABBIT_PASSWORD@$RABBIT_HOST
rabbit_host = $RABBIT_HOST
dhcpbridge_flagfile=/etc/nova/nova.conf
dhcpbridge=/usr/bin/nova-dhcpbridge
force_dhcp_release=true
state_path=/var/lib/nova
enabled_apis=osapi_compute,metadata
my_ip = $MY_IP
use_neutron = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver
scheduler_default_filters = AllHostsFilter
allow_migrate_to_same_host = True
allow_resize_to_same_host = True

[vnc]
enabled = True
vncserver_listen = 0.0.0.0
vncserver_proxyclient_address = merlin.hpc.rug.nl
novncproxy_base_url = https://merlin.hpc.rug.nl:6080/vnc_auto.html

[libvirt]
virt_type = kvm
images_type = rbd
images_rbd_pool = volumes
images_rbd_ceph_conf = /etc/ceph/ceph.conf
rbd_user = volumes
rbd_secret_uuid = $RBD_SECRET_UUID


[glance]
api_servers = http://$GLANCE_CONTROLLER_HOST:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp

[api]
auth_strategy = keystone

[keystone_authtoken]
auth_uri = https://$KEYSTONE_HOST:5000
auth_url = https://$KEYSTONE_HOST:35357
memcached_servers = $MEMCACHED_HOST:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = $NOVA_USER
password = $NOVA_PASSWORD

[api_database]
connection = mysql+pymysql://$NOVA_COMPUTE_USER:$NOVA_PASSWORD@mariadb/nova_api

[barbican]
[cache]

[cells]
enable=False

[placement]
os_region_name = RegionOne
project_domain_name = Default
project_name = service
auth_type = password
user_domain_name = Default
auth_url = https://$KEYSTONE_HOST:35357/v3
username = $NOVA_PLACEMENT_USER
password = $NOVA_PLACEMENT_PASSWORD

[wsgi]
api_paste_config=/etc/nova/api-paste.ini

[neutron]
url = http://$NEUTRON_CONTROLLER_HOST:9696
auth_url = https://$KEYSTONE_HOST:35357
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = $NEUTRON_USER
password = $NEUTRON_PASSWORD

[cinder]
os_region_name = RegionOne

EOF

cat << EOF > /etc/neutron/neutron.conf
[DEFAULT]
service_plugins = router
allow_overlapping_ips = True
transport_url = rabbit://$RABBIT_USER:$RABBIT_PASSWORD@$RABBIT_HOST
auth_strategy = keystone
core_plugin = ml2
global_physnet_mtu = $GLOBAL_PHYSNET_MTU

[keystone_authtoken]
auth_uri = https://$KEYSTONE_HOST:5000
auth_url = https://$KEYSTONE_HOST:35357
memcached_servers = $MEMCACHED_HOST:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = $NEUTRON_USER
password = $NEUTRON_PASSWORD

[nova]
auth_url = https://$KEYSTONE_HOST:35357
auth_type = password
project_domain_name = Default
user_domain_name = Default
region_name = RegionOne
project_name = service
username = $NOVA_USER
password = $NOVA_PASSWORD

EOF


cat << EOF > /etc/neutron/l3_agent.ini

[DEFAULT]
interface_driver = linuxbridge
external_network_bridge =

EOF

cat << EOF > /etc/neutron/dhcp_agent.ini

[DEFAULT]
interface_driver = linuxbridge
dhcp_driver = neutron.agent.linux.dhcp.Dnsmasq
enable_isolated_metadata = true

EOF

cat << EOF > /etc/neutron/metadata_agent.ini

[DEFAULT]
nova_metadata_ip = $NEUTRON_CONTROLLER_HOST
metadata_proxy_shared_secret = $METADATA_SECRET

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
vni_ranges = 1:100

[securitygroup]
enable_ipset = true

EOF

cat << EOF > /etc/neutron/plugins/ml2/linuxbridge_agent.ini

[linux_bridge]
physical_interface_mappings = $PHYSICAL_INTERFACE_MAPPINGS

[securitygroup]
enable_security_group = true
firewall_driver = neutron.agent.linux.iptables_firewall.IptablesFirewallDriver

[vxlan]
enable_vxlan = True
l2_population = True
local_ip = $OVERLAY_IP

EOF

if [ $USE_CEPH = true ]
    then cat << EOF > /etc/ceph/ceph.conf
[global]
fsid = $FSID
mon_initial_members = $MON_INITIAL_MEMBERS
mon_host = $MON_HOST
auth_cluster_required = cephx
auth_service_required = cephx
auth_client_required = cephx

# Your network address
public network = $PUBLIC_NETWORK
osd pool default size = $OSD_POOL_DEFAULT_SIZE

[client.compute]
keyring = /etc/ceph/ceph.client.compute.keyring
EOF

cat << EOF > /etc/neutron/l3_agent.ini

[DEFAULT]
interface_driver = linuxbridge
external_network_bridge =

EOF

echo "172.23.59.101        merlin.hpc.rug.nl" >> /etc/hosts
