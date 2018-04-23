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
    && apt-get -y clean

# set admin token TODO: make this a secret
# in volume of met env
COPY keystone.conf /etc/keystone/keystone.conf

RUN mkdir /etc/keystone/fernet-keys

RUN chown keystone: /etc/keystone/fernet-keys

COPY bootstrap.sh /etc/bootstrap.sh

CMD apachectl -DFOREGROUND
