#!/bin/bash
#
# Generate config files from environments values.
# These are to be passed to the docker container using -e

cat << EOF > /etc/heat/heat.conf

[database]
connection = mysql+pymysql://heat:$HEAT_PASSWORD@$MYSQL_HOST/heat

[DEFAULT]
transport_url = rabbit://$RABBIT_USER:$RABBIT_PASSWORD@$RABBIT_HOST
heat_metadata_server_url = http://$HEAT_HOST:8000
heat_waitcondition_server_url = http://$HEAT_HOST:8000/v1/waitcondition


[keystone_authtoken]
auth_uri = https://$KEYSTONE_HOST:5000
auth_url = https://$KEYSTONE_HOST:35357
memcached_servers = $MEMCACHED_HOST:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = $HEAT_USER
password = $HEAT_PASSWORD

[trustee]
auth_plugin = password
auth_url = https://$KEYSTONE_HOST:35357
username = $HEAT_USER
password = $HEAT_PASSWORD
user_domain_name = Default

EOF
