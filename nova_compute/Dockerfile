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
        nova-compute \
        neutron-linuxbridge-agent \
	neutron-l3-agent \
        neutron-dhcp-agent \
        neutron-metadata-agent \
        python-ceph \
        python-rbd \
        ceph-common \ 
    && apt-get -y clean

COPY write_conf.sh /etc/write_conf.sh

COPY run.sh /etc/run.sh

CMD ["/etc/run.sh"]
