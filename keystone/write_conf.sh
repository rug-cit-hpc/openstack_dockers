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

# Execute further arguments. useful when calling this script with ansible
$@
