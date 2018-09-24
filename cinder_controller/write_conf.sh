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
enabled_backends = RBD-backend
my_ip = $MY_IP

[keystone_authtoken]
auth_uri = https://$KEYSTONE_HOST:5000
auth_url = https://$KEYSTONE_HOST:35357
memcached_servers = $MEMCACHED_HOST:11211
auth_type = password
project_domain_name = Default
user_domain_name = Default
project_name = service
username = $CINDER_USER
password = $CINDER_PASSWORD

[oslo_concurrency]
lock_path = /var/lib/cinder/tmp

[RBD-backend]
volume_backend_name = RBD-backend
rbd_pool = volumes
rbd_user = volumes
rbd_secret_uuid = $RBD_SECRET_UUID
volume_driver = cinder.volume.drivers.rbd.RBDDriver
rbd_ceph_conf = /etc/ceph/ceph.conf

EOF
