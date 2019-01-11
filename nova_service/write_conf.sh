#!/bin/bash
#
# Generate config files from environments values.
# These are to be passed to the docker container using -e

cat << EOF > /etc/nova/nova.conf

[api_database]
connection = mysql+pymysql://$NOVA_USER:$NOVA_PASSWORD@mariadb/nova_api

[database]
connection = mysql+pymysql://$NOVA_USER:$NOVA_PASSWORD@mariadb/nova

[DEFAULT]
cert = /certs/merlin.hpc.rug.nl.crt
key = /certs/merlin.hpc.rug.nl.key
use_neutron = True
my_ip = $MY_IP
transport_url = rabbit://$RABBIT_USER:$RABBIT_PASSWORD@$MY_IP
scheduler_default_filters = AllHostsFilter
allow_migrate_to_same_host = True
allow_resize_to_same_host = True
firewall_driver = nova.virt.firewall.NoopFirewallDriver
enabled_apis=osapi_compute,metadata
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
service_metadata_proxy = True
metadata_proxy_shared_secret = $METADATA_SECRET

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

[vnc]
enabled = true
vncserver_listen = $MY_IP
vncserver_proxyclient_address = $MY_IP

[glance]
api_servers = http://$GLANCE_CONTROLLER_HOST:9292

[oslo_concurrency]
lock_path = /var/lib/nova/tmp

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

EOF

echo "172.23.59.101        merlin.hpc.rug.nl" >> /etc/hosts
