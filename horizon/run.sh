#!/bin/bash

#Making the console log console again...
tail -f /var/log/horizon.log &

tail -f /var/log/apache2/* &

apachectl -DFOREGROUND
