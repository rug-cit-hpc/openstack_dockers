#!/bin/bash

# Create admin-openrc.sh from secrets that are in the environment during bootstrap.
/etc/write_conf.sh

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
