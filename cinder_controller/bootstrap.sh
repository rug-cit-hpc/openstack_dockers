#!/bin/bash

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

# Write the config files
/etc/write_conf.sh

# create database for cinder
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h "$MYSQL_HOST" << EOF
drop database  if exists cinder;
create database cinder;
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY "$CINDER_PASSWORD";
GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY "$CINDER_PASSWORD";
EOF

openstack user create cinder --domain default --password "$CINDER_PASSWORD"
openstack role add --user cinder --project service admin

openstack service create --name cinderv2 --description "OpenStack Block Service" volumev2
openstack service create --name cinderv3 --description "OpenStack Block Service" volumev3

openstack endpoint create volumev2 public http://"${CINDER_HOST}":8776/v2/%\(project_id\)s --region RegionOne
openstack endpoint create volumev2 internal http://"${CINDER_HOST}":8776/v2/%\(project_id\)s --region RegionOne
openstack endpoint create volumev2 admin http://"${CINDER_HOST}":8776/v2/%\(project_id\)s --region RegionOne

openstack endpoint create volumev3 public http://"${CINDER_HOST}":8776/v3/%\(project_id\)s --region RegionOne
openstack endpoint create volumev3 internal http://"${CINDER_HOST}":8776/v3/%\(project_id\)s --region RegionOne
openstack endpoint create volumev3 admin http://"${CINDER_HOST}":8776/v3/%\(project_id\)s --region RegionOne

# sync the database
cinder-manage db sync


