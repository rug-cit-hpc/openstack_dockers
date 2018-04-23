#!/bin/bash

# Create admin-openrc.sh from secrets that are in the environment during bootstrap.
cat << EOF > /root/admin-openrc.sh
#!/bin/bash
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=${OS_PASSWORD}
export OS_AUTH_URL=http://${KEYSTONE_HOST}:35357/v3
export OS_IDENTITY_API_VERSION=3

export GLANCE_USER_NAME=glance
export GLANCE_PASSWORD=${GLANCE_PASSWORD}
export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_IMAGE_API_VERSION=2
EOF

source /root/admin-openrc.sh

# Write the config files
/etc/write_conf.sh

# create database for glance
mysql -uroot -p"$MYSQL_ROOT_PASSWORD" -h "$MYSQL_HOST" << EOF
drop database  if exists glance;
create database glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY "$GLANCE_PASSWORD";
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY "$GLANCE_PASSWORD";
EOF

openstack user create "$GLANCE_USER" --domain default --password "$GLANCE_PASSWORD"
openstack role add --user glance --project service admin
openstack service create --name glance --description "OpenStack Image Service" image
openstack endpoint create glance admin http://"${GLANCE_HOST}":9292 --region RegionOne
openstack endpoint create glance public http://"${GLANCE_HOST}":9292 --region RegionOne
openstack endpoint create glance internal http://"${GLANCE_HOST}":9292 --region RegionOne

# Workaround, see https://bugs.launchpad.net/glance/+bug/1697835
sed -i "/op.drop_index('ix_images_is_public', 'images')/a \ \ \ \ op.execute(\"\"\"ALTER TABLE images DROP CONSTRAINT CONSTRAINT_1\"\"\")" \
    /usr/lib/python2.7/dist-packages/glance/db/sqlalchemy/alembic_migrations/versions/ocata01_add_visibility_remove_is_public.py

# sync the database
su -s /bin/sh -c "glance-manage db_sync" glance
