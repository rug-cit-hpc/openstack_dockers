FROM ubuntu:16.04
# install packages

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5EDB1B62EC4926EA

RUN set -x \
    && echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu xenial-updates/ocata main" > /etc/apt/sources.list.d/ocata.list \
    && apt-get -y update \
    && apt-get -y install ubuntu-cloud-keyring \
    && apt-get -y update \
    && apt-get -y install \
        mysql-client \
        python-mysqldb \
        python-openstackclient \
        neutron-server \
        neutron-plugin-ml2 \
        neutron-linuxbridge-agent \
        neutron-l3-agent \
        neutron-metadata-agent \
    && apt-get -y clean

# add bootstrap script and make it executable
COPY bootstrap.sh /etc/bootstrap.sh

# Workaround for vlan_transparent parameter set to None.
COPY db_base_plugin_v2.py /usr/lib/python2.7/dist-packages/neutron/db/db_base_plugin_v2.py

COPY run.sh /etc/run.sh
COPY write_conf.sh /etc/write_conf.sh

CMD ["/etc/run.sh"]
