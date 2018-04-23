# How to build
```
docker build . -t hpc/openstack-cinder-storage
```

# Bootstrap
```
 docker run --rm
    -e "MY_IP={{ ansible_default_ipv4.address }}"
    -e "CINDER_HOST={{ hostvars[groups['cinder-storage'][0]]['ansible_default_ipv4']['address'] }}"
    -e "CINDER_PASSWORD={{ secrets['CINDER_PASSWORD'] }}"
    -e "CINDER_USER=cinder"
    -e "KEYSTONE_HOST={{ hostvars[groups['keystone'][0]]['ansible_default_ipv4']['address'] }}"
    -e "MYSQL_HOST={{ hostvars[groups['databases'][0]]['ansible_default_ipv4']['address'] }}"
    -e "MYSQL_ROOT_PASSWORD={{ secrets['MYSQL_ROOT_PASSWORD'] }}"
    -e "OS_PASSWORD={{ secrets['OS_PASSWORD'] }}"
    -e "RABBIT_HOST={{ hostvars[groups['rabbitmq'][0]]['ansible_default_ipv4']['address'] }}"
    -e "RABBIT_PASSWORD={{ secrets['RABBIT_PASSWORD'] }}"
    -e "RABBIT_USER=openstack"
 hpc/openstack-cinder /etc/bootstrap.sh

```

# Run an image

```
/usr/bin/docker run \
    -e "MY_IP={{ ansible_default_ipv4.address }}"
    -e "CINDER_HOST={{ hostvars[groups['cinder-storage'][0]]['ansible_default_ipv4']['address'] }}"
    -e "CINDER_PASSWORD={{ secrets['CINDER_PASSWORD'] }}"
    -e "CINDER_USER=cinder"
    -e "KEYSTONE_HOST={{ hostvars[groups['keystone'][0]]['ansible_default_ipv4']['address'] }}"
    -e "MYSQL_HOST={{ hostvars[groups['databases'][0]]['ansible_default_ipv4']['address'] }}"
    -e "MYSQL_ROOT_PASSWORD={{ secrets['MYSQL_ROOT_PASSWORD'] }}"
    -e "OS_PASSWORD={{ secrets['OS_PASSWORD'] }}"
    -e "RABBIT_HOST={{ hostvars[groups['rabbitmq'][0]]['ansible_default_ipv4']['address'] }}"
    -e "RABBIT_PASSWORD={{ secrets['RABBIT_PASSWORD'] }}"
    -e "RABBIT_USER=openstack"
    -p 8776:8776 \
  hpc/openstack-cinder-storage
```
