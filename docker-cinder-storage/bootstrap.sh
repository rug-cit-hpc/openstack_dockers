#!/bin/bash

# Create admin-openrc.sh from secrets that are in the environment during bootstrap.
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

# Write the config files
/etc/write_conf.sh

# create a LVM physical volume and volume group.
# This device should be available tpo the container
pvcreate /dev/cinder_storage_volume
vgcreate cinder-volumes /dev/cinder_storage_volume

