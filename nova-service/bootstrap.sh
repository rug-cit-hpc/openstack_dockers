#!/bin/bash
#
# This script sets up the openstack users and regions..
# as well as the database for the nova controller.
# This guide was used:
# https://docs.openstack.org/ocata/install-guide-ubuntu/nova-controller-install.

# write the configuration files with values from the environment.
/etc/write_conf.sh

cat << EOF > /root/admin-openrc.sh
#!/bin/bash
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=${OS_PASSWORD}
export OS_AUTH_URL=http://${KEYSTONE_HOST}:35357/v3
export OS_IDENTITY_API_VERSION=3

export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_IMAGE_API_VERSION=2

EOF

source /root/admin-openrc.sh

# create database for nova
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h "$MYSQL_HOST" << EOF

DROP DATABASE  IF EXISTS nova;
DROP DATABASE  IF EXISTS nova_compute;  -- db for nova compute service
DROP DATABASE  IF EXISTS nova_api;
DROP DATABASE  IF EXISTS nova_cell0;
CREATE DATABASE nova;
CREATE DATABASE nova_compute;
CREATE DATABASE nova_api;
CREATE DATABASE nova_cell0;

GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' \
    IDENTIFIED BY "${NOVA_PASSWORD}";

GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' \
    IDENTIFIED BY "${NOVA_PASSWORD}";

GRANT ALL PRIVILEGES ON nova_compute.* TO 'nova_compute'@'localhost' \
    IDENTIFIED BY "${NOVA_PASSWORD}";

GRANT ALL PRIVILEGES ON nova_compute.* TO 'nova_compute'@'%' \
    IDENTIFIED BY "${NOVA_PASSWORD}";

GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' \
    IDENTIFIED BY "${NOVA_PASSWORD}";

GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' \
    IDENTIFIED BY "${NOVA_PASSWORD}";

GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'localhost' \
    IDENTIFIED BY "${NOVA_PASSWORD}";

GRANT ALL PRIVILEGES ON nova_cell0.* TO 'nova'@'%' \
    IDENTIFIED BY "${NOVA_PASSWORD}";

EOF

openstack user create nova --domain default --password "$NOVA_PASSWORD"
openstack role add --project service --user nova admin
openstack service create --name nova --description "OpenStack Compute" compute

# compute endpoints
openstack endpoint create --region RegionOne \
    compute public http://"$MY_IP":8774/v2.1

openstack endpoint create --region RegionOne \
    compute internal http://"$MY_IP":8774/v2.1

openstack endpoint create --region RegionOne \
    compute admin http://"$MY_IP":8774/v2.1

openstack user create --domain default --password "$NOVA_PLACEMENT_PASSWORD" placement
openstack role add --project service --user placement admin

openstack service create --name placement --description "Placement API" placement

# placement endpoints
openstack endpoint create --region RegionOne placement public http://"$MY_IP":8778
openstack endpoint create --region RegionOne placement internal http://"$MY_IP":8778
openstack endpoint create --region RegionOne placement admin http://"$MY_IP":8778

#Populate the nova-api database
nova-manage api_db sync

# Register the cell0 database:
nova-manage cell_v2 map_cell0

# Create the cel1 cell
nova-manage cell_v2 create_cell --name=cell1 --verbose

# sync the database
nova-manage db sync

e nova_api;

# Prevent crashes when nova api server tries to insert None in config_drive
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h "$MYSQL_HOST" << EOF

alter table nova_api.build_requests drop constraint CONSTRAINT_1;

EOF

# https://bugs.launchpad.net/packstack/+bug/1673305
# discover compute hosts.
nova-manage cell_v2 discover_hosts

# Verify nova cell0 and cell1 are registered correctly:
nova-manage cell_v2 list_cells
