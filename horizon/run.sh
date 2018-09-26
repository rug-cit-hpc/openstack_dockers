#!/bin/bash

#Making the console log console again...
tail -f /var/log/horizon.log &

tail -f /var/log/apache2/* &

cat /etc/openstack-dashboard/local_settings.py >> \
    /usr/share/openstack-dashboard/openstack_dashboard/settings.py


apachectl -DFOREGROUND
