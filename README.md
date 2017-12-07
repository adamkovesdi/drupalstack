
# DevOps Challenge implementation by adamkov

## Creating the LAMP stack machine 

### a) Vagrant box implementation

LAMP stack machine is a Vagrant VM based on Ubuntu Xenial image  
Vagrant file for setting up a new VM is present in [vagrant/Vagrantfile](vagrant/Vagrantfile)  
Vagrant VM provisioning shell script can be found in [vagrant/initvm.sh](vagrant/initvm.sh)   

Launch and connect to Vagrant box:
```
$ vagrant up
$ vagrant ssh

login credentials
user: vagrant
pass: vagrant
```

#### Use Ansible to install the LAMP stack

### b) single docker image implementation

### implementation c) docker-compose for the whole stack

### implementation d) AWS E2C instance

TODO: AWS account required TBC.

