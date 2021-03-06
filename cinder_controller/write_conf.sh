#!/bin/bash
#
# Generate config files from environments values.
# These are to be passed to the docker container using -e

cat << EOF > /etc/cinder/cinder.conf

[database]
connection = mysql+pymysql://$CINDER_USER:$CINDER_PASSWORD@$MYSQL_HOST/cinder

[DEFAULT]
auth_strategy = keystone
transport_url = rabbit://$RABBIT_USER:$RABBIT_PASSWORD@$MY_IP
my_ip = $MY_IP

[keystone_authtoken]
auth_uri = http://$KEYSTONE_HOST:5000
auth_url = http://$KEYSTONE_HOST:35357
memcached_servers = $MEMCACHED_HOST:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = $CINDER_USER
password = $CINDER_PASSWORD

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp

EOF
