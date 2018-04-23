#!/bin/bash

#Making the console log console again...
tail -f /var/log/horizon.log &

apachectl -DFOREGROUND
