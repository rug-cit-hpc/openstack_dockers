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
    && apt-get -y install openstack-dashboard \
                          python-openstackclient \
    && apt-get -y clean


EXPOSE 80 

COPY openstack-dashboard.conf /etc/apache2/conf-available/openstack-dashboard.conf

COPY local_settings.py /etc/openstack-dashboard/local_settings.py

# Add a redirect to /keystone instead of the "It works! page"
COPY 000-default.conf /etc/apache2/sites-available

COPY run.sh /etc/run.sh

RUN chown -R www-data: /var/lib/openstack-dashboard/

RUN touch /var/log/horizon.log

RUN chown www-data: /var/log/horizon.log

RUN a2enmod ssl
RUN a2enmod headers
RUN a2enmod rewrite

#RUN  chown /var/lib/openstack-dashboard/secret_key horizon

CMD /etc/run.sh

