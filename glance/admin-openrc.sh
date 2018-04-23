#!/bin/bash
# a admin-openrc.sh file

# To create the Identity service credentials
GLANCE_USER_NAME=glance
GLANCE_PASSWORD=geheim
export OS_IDENTITY_API_VERSION=3
export OS_USERNAME=admin
export OS_PASSWORD=geheim
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://${KEYSTONE_HOST}:35357/v3

export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_IMAGE_API_VERSION=2
