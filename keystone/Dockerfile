# Build keystone. It needs to be run with
# --add-host=mariadb:<ip mariadb listens tp>
# Wen starting with an initialized db,
# run keystone-manage db_sync from this docker first:
# $ docker run hpc/keystone --add-host=mariadb:<ip mariadb> "keystone-manage db_sync"

FROM ubuntu:16.04

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5EDB1B62EC4926EA

RUN set -x \
    && echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu xenial-updates/ocata main" > /etc/apt/sources.list.d/ocata.list \
    && apt-get -y update \
    && apt-get -y install \
    && apt-get -y install keystone python-openstackclient \
    && apt-get -y install libapache2-mod-shib2 \
    && apt-get -y clean

# set admin token TODO: make this a secret
# in volume of met env
COPY apache-keystone.conf /etc/apache2/sites-available/keystone.conf

COPY shibboleth2.xml /etc/shibboleth/shibboleth2.xml
COPY attribute-map.xml /etc/shibboleth/attribute-map.xml
COPY attribute-policy.xml /etc/shibboleth/attribute-policy.xml

COPY sso_callback_template.html /etc/keystone/sso_callback_template.html

RUN mkdir /var/run/shibboleth

COPY bootstrap.sh /etc/bootstrap.sh
COPY write_conf.sh /etc/write_conf.sh
RUN chmod +x /etc/write_conf.sh
COPY run.sh /etc/run.sh

RUN mkdir /etc/keystone/fernet-keys

RUN chown keystone: /etc/keystone/fernet-keys

RUN a2enmod shib2

COPY bootstrap.sh /etc/bootstrap.sh

# Testing only!!!
RUN mkdir -p /var/www/html/secure
RUN apt-get -y install php libapache2-mod-php
COPY test.php /var/www/html/secure/test.php

CMD /etc/run.sh
