# ubuntu 16.04 openstack ocata neutron controler node

## How to build the docker image.
```
docker  build . -t="hpc/neutroncontroller"
```

## How to bootstrap the service.
Before we can take the container into service we need accounts in keystone.
We also need an initial database. Both of these tasks are performed by the bootstrap script.
```
docker run --rm --it --add-host="controller:<keystone_ip>" hpc/neutroncontroler /etc/bootstrap.sh
```

## How to run
This image needs a lot of environment variables. It should be run via the `hpc-cloud` ansible repository.


## Notes
This image is designed to be deployed from the [hpc-cloud repo](https://git.webhosting.rug.nl/HPC/hpc-cloud)
The -p option is added to the run command to make the container accessible from (containers on ) other hosts than the container host.
