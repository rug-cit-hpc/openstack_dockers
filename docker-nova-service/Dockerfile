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
        python-oslo.cache \
        nova-api \
        nova-conductor \
        nova-consoleauth \
        nova-novncproxy \
        nova-scheduler \
        nova-placement-api \
    && apt-get -y clean

EXPOSE 8774
EXPOSE 8778

# add bootstrap script and make it executable
COPY bootstrap.sh /etc/bootstrap.sh
COPY run.sh /etc/run.sh
COPY write_conf.sh /etc/write_conf.sh

CMD ["/etc/run.sh"]
