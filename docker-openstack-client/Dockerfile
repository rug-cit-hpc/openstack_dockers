FROM ubuntu:16.04
# install packages

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5EDB1B62EC4926EA

RUN set -x \
    && echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu xenial-updates/ocata main" > /etc/apt/sources.list.d/ocata.list \
    && apt-get -y update \
    && apt-get -y install ubuntu-cloud-keyring \
    && apt-get -y update \
    && apt-get -y install \
        python-openstackclient \
    && apt-get -y clean

# add bootstrap script and make it executable
COPY admin-openrc.sh /root/admin-openrc.sh

COPY demo-openrc.sh /root/demo-openrc.sh

