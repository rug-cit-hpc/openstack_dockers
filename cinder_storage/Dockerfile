FROM ubuntu:16.04
# install packages

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 5EDB1B62EC4926EA

RUN set -x \
    && echo "deb http://ubuntu-cloud.archive.canonical.com/ubuntu xenial-updates/ocata main" > /etc/apt/sources.list.d/ocata.list \
    && apt-get -y update \
    && apt-get -y install ubuntu-cloud-keyring \
    && apt-get -y update \
    && apt-get -y install \
        cinder-volume \
        mysql-client \
        python-mysqldb \
        python-openstackclient \
        python-oslo.cache \
        lvm2 \
        python-ceph \
        python-rbd \

    && apt-get -y clean

EXPOSE 8776

#file that writes configs
COPY write_conf.sh /etc/write_conf.sh
# add bootstrap script and make it executable
COPY bootstrap.sh /etc/bootstrap.sh

COPY run.sh /etc/run.sh

RUN chown root.root /etc/bootstrap.sh && chmod a+x /etc/bootstrap.sh
RUN chown root.root /etc/run.sh && chmod a+x /etc/run.sh

CMD ["/etc/run.sh"]
