#!/bin/bash
# a admin-openrc.sh file
KEYSTONE_HOST=keystone  # to be set via docker run --host option
export OS_IDENTITY_API_VERSION=3
export OS_USERNAME=demo
export OS_PASSWORD=geheim
export OS_TENANT_NAME=admin
export OS_AUTH_URL=http://${KEYSTONE_HOST}:5000/v3

export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=demo
export OS_IMAGE_API_VERSION=2
