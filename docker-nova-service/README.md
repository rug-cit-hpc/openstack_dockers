# ubuntu 16.04 openstack ocata nova controler node

# How to build the docker image.
```
docker  build . -t="hpc/openstack-nova-service"
```

# How to bootstrap the service.
Before we can take the container into service we need accounts in keystone.
We also need an initial database. Both of these tasks are performed by the bootstrap script.
```
docker run --rm --it --add-host="controller:<keystone_ip>" hpc/novacontroler /etc/bootstrap.sh
```

# How to run
```
docker run --rm --add-host="controller:<keystone_ip>" --privileged -p 8774:8774 -p 8778:8778 hpc/novacontroler /etc/run.sh
```

Where keystone_ip is the ip of the docker host where our keystone service is running.

# Notes
This image is designed to be deployed from the [hpc-cloud repo](https://git.webhosting.rug.nl/HPC/hpc-cloud)
The -p option is added to the run command to make the container accessible from (containers on ) other hosts than the container host.
