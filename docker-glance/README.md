# How to build
```
docker build . -t hpc/openstack-glance
```

# Bootstrap
```
 docker run --rm
 -e "RABBIT_HOST={{ hostvars[groups['rabbitmq'][0]]['ansible_default_ipv4']['address'] }}"
 -e "MEMCACHED_HOST={{ hostvars[groups['memcached'][0]]['ansible_default_ipv4']['address'] }}"
 -e "MYSQL_HOST={{ hostvars[groups['databases'][0]]['ansible_default_ipv4']['address'] }}"
 -e "MYSQL_ROOT_PASSWORD=geheim"
 -e "KEYSTONE_HOST={{ hostvars[groups['keystone'][0]]['ansible_default_ipv4']['address'] }}"
 -e "GLANCE_HOST={{ hostvars[groups['glance'][0]]['ansible_default_ipv4']['address'] }}"
 -e "GLANCE_PASSWORD=geheim"
 hpc/openstack-glance /etc/bootstrap.sh

```

# Run an image

```
/usr/bin/docker run --name %n \
  -e "RABBIT_HOST={{ hostvars[groups['rabbitmq'][0]]['ansible_default_ipv4']['address'] }}" \
  -e "MEMCACHED_HOST={{ hostvars[groups['memcached'][0]]['ansible_default_ipv4']['address'] }}" \
  -e "MYSQL_HOST={{ hostvars[groups['databases'][0]]['ansible_default_ipv4']['address'] }}" \
  -e "MYSQL_ROOT_PASSWORD=geheim" \
  -e "KEYSTONE_HOST={{ hostvars[groups['keystone'][0]]['ansible_default_ipv4']['address'] }}" \
  -e "GLANCE_HOST={{ hostvars[groups['glance'][0]]['ansible_default_ipv4']['address'] }}" \
  -e "GLANCE_PASSWORD=geheim" \
  -p 9292:9292 \
  hpc/openstack-glance
```
