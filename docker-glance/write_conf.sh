#!/bin/bash
#
# Generate config files from environments values.
# These are to be passed to the docker container using -e

cat << EOF > /etc/glance/glance-api.conf

[database]
connection = mysql+pymysql://$GLANCE_USER:$GLANCE_PASSWORD@$MYSQL_HOST/glance
[image_format]
[keystone_authtoken]
auth_uri = http://$KEYSTONE_HOST:5000
auth_url = http://$KEYSTONE_HOST:35357
memcached_servers = $MEMCACHED_HOST:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = $GLANCE_PASSWORD

[oslo_messaging_notifications]
driver = messagingv2

[oslo_messaging_rabbit]
rabbit_host = $RABBIT_HOST
rabbit_userid = $RABBIT_USER
rabbit_password = $RABBIT_PASSWORD

[paste_deploy]
flavor = keystone


[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/

EOF


cat << EOF > /etc/glance/glance-registry.conf

[DEFAULT]
workers = 4
rpc_backend = rabbit

[database]
connection = mysql+pymysql://$GLANCE_USER:$GLANCE_PASSWORD@$MYSQL_HOST/glance

[glance_store]
stores = file,http
default_store = file
filesystem_store_datadir = /var/lib/glance/images/

[keystone_authtoken]
auth_uri = http://$KEYSTONE_HOST:5000
auth_url = http://$KEYSTONE_HOST:35357
memcached_servers = $MEMCACHED_HOST:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = glance
password = $GLANCE_PASSWORD

[oslo_messaging_notifications]
driver = messagingv2

[oslo_messaging_rabbit]
rabbit_host = $RABBIT_HOST
rabbit_userid = $RABBIT_USER
rabbit_password = $RABBIT_PASSWORD

[paste_deploy]
flavor = keystone

EOF
