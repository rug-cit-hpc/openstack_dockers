#!/bin/bash

# Create admin-openrc.sh from secrets that are in the environment during bootstrap.
cat << EOF > /root/admin-openrc.sh
#!/bin/bash
export OS_TENANT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=${OS_PASSWORD}
export OS_AUTH_URL=https://${KEYSTONE_HOST}:35357/v3
export OS_IDENTITY_API_VERSION=3
EOF

# Create demo-openrc.sh
cat << EOF > /root/demo-openrc.sh
#!/bin/bash
export OS_TENANT_NAME=demo
export OS_USERNAME=demo
export OS_PASSWORD=${OS_DEMO_PASSWORD}
export OS_AUTH_URL=https://${KEYSTONE_HOST}:35357/v3
export OS_IDENTITY_API_VERSION=3
EOF

source /root/admin-openrc.sh

sleep 3

openstack project create --domain default \
      --description "Service Project" service

sleep 3

openstack project create --domain default \
  --description "Demo Project" demo

sleep 3

openstack user create --domain default \
  --password "$OS_DEMO_PASSWORD" demo

sleep 3

openstack role create user

sleep 3

openstack role add --project demo --user demo user
