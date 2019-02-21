#!/bin/bash
# start nova compute service

chown keystone: /etc/keystone/fernet-keys
chmod 700 /etc/keystone/fernet-keys

cat << EOF > /etc/keystone/keystone.conf
[DEFAULT]

verbose = true
# debug = true
log_file = /var/log/keystone/keystone.log

[database]
connection = mysql+pymysql://keystone:$KEYSTONE_PASSWORD@mariadb/keystone

[token]
provider = fernet

[auth]
methods = password,token,mapped,openid,saml2

[federation]
trusted_dashboard = https://merlin.hpc.rug.nl/horizon/auth/websso/
sso_calback_template = /etc/keystone/sso_calback_template.html

[mapped]
remote_id_attribute = Shib-Identity-Provider

[identity]
default_domain_id = default
EOF

# Start apache
a2enmod ssl
apachectl -DFOREGROUND &

tail -f /var/log/apache2/* &

chown _shibd: /etc/shibboleth/sp*.pem

shibd -f -F &

# If any process fails, kill the rest.
# This ensures the container stops and systemd will restart it.

wait -n
pkill -P $$

