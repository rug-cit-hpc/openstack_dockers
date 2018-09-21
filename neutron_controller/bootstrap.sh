#!/bin/bash
#
# This script sets up the openstack users and regions..
# as well as the database for the nova controller.
# This guide was used:
# https://docs.openstack.org/ocata/install-guide-ubuntu/nova-controller-install.

# Create admin-openrc.sh from secrets that are in the environment during bootstrap.
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

source /root/admin-openrc.sh

# create database for neutron.
SQL_SCRIPT=/root/neutron.sql
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h "$MYSQL_HOST" << EOF
DROP DATABASE  IF EXISTS neutron;
CREATE DATABASE neutron;

GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' \
    IDENTIFIED BY "${NEUTRON_PASSWORD}";

GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' \
    IDENTIFIED BY "${NEUTRON_PASSWORD}";
EOF

openstack user create "$NEUTRON_USER" --domain default --password "$NEUTRON_PASSWORD"
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network

# neutron endpoints
openstack endpoint create --region RegionOne \
  network public http://$MY_IP:9696

openstack endpoint create --region RegionOne \
  network internal http://$MY_IP:9696

openstack endpoint create --region RegionOne \
  network admin http://$MY_IP:9696

# population of the database requires complete server and plug-in configuration files.
/etc/write_conf.sh

# Ugly hacks to prevent the manage command from failing
sed -i "/    op.drop_column('networks', 'shared')/ s/^#*/#/" /usr/lib/python2.7/dist-packages/neutron/db/migration/alembic_migrations/versions/liberty/contract/4ffceebfada_rbac_network.py
sed -i "/    op.drop_column('subnets', 'shared')/ s/^#*/#/" /usr/lib/python2.7/dist-packages/neutron/db/migration/alembic_migrations/versions/liberty/contract/4ffceebfada_rbac_network.py
sed -i "/    op.drop_column('qos_policies', 'shared')/ s/^#*/#/" /usr/lib/python2.7/dist-packages/neutron/db/migration/alembic_migrations/versions/mitaka/contract/c6c112992c9_rbac_qos_policy.py

neutron-db-manage --config-file /etc/neutron/neutron.conf \
                  --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head

# And now we drop the colums and constraints that the ORM fails to drop.
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h "$MYSQL_HOST" neutron << EOF

ALTER TABLE networks DROP CONSTRAINT CONSTRAINT_2;
alter table networks drop column shared;

ALTER TABLE subnets DROP CONSTRAINT CONSTRAINT_2;
ALTER TABLE subnets DROP COLUMN shared;

ALTER TABLE qos_policies DROP CONSTRAINT CONSTRAINT_1;
ALTER TABLE qos_policies drop column shared

EOF
