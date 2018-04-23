#!/bin/bash

# Create admin-openrc.sh from secrets that are in the environment during bootstrap.
cat << EOF > /root/admin-openrc.sh
#!/bin/bash
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=${OS_PASSWORD}
export OS_AUTH_URL=http://${KEYSTONE_HOST}:35357/v3
export OS_IDENTITY_API_VERSION=3

export HEAT_USER=heat
export HEAT_PASSWORD=${HEAT_PASSWORD}
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_IMAGE_API_VERSION=2
EOF

source /root/admin-openrc.sh

# Write the config files
/etc/write_conf.sh

# create database for heat
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h "$MYSQL_HOST" << EOF
drop database  if exists heat;
create database heat;
GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'localhost' IDENTIFIED BY "$HEAT_PASSWORD";
GRANT ALL PRIVILEGES ON heat.* TO 'heat'@'%' IDENTIFIED BY "$HEAT_PASSWORD";
EOF

openstack user create "$HEAT_USER" --domain Default --password "$HEAT_PASSWORD"
openstack role add --project service --user heat admin

openstack service create --name heat --description "Orchestration" orchestration
openstack service create --name heat-cfn --description "Orchestration" cloudformation

openstack endpoint create orchestration public http://"${HEAT_HOST}":8004/v1/%\(tenant_id\)s --region RegionOne
openstack endpoint create orchestration internal http://"${HEAT_HOST}":8004/v1/%\(tenant_id\)s --region RegionOne
openstack endpoint create orchestration admin http://"${HEAT_HOST}":8004/v1/%\(tenant_id\)s --region RegionOne

openstack endpoint create cloudformation public http://"${HEAT_HOST}":8000/v1 --region RegionOne
openstack endpoint create cloudformation internal http://"${HEAT_HOST}":8000/v1 --region RegionOne
openstack endpoint create cloudformation admin http://"${HEAT_HOST}":8000/v1 --region RegionOne

openstack domain create --description "Stack projects and users" heat

openstack user create --domain heat --password "$HEAT_PASSWORD"  heat_domain_admin
openstack role add --domain heat --user-domain heat --user heat_domain_admin admin

openstack role create heat_stack_owner
openstack role add --project demo --user demo heat_stack_owner
openstack role create heat_stack_user

# sync the database
su -s /bin/sh -c "heat-manage db_sync" heat
