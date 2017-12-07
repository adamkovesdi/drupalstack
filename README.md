# DevOps Challenge entry by adamkov

## Creating the LAMP stack machine 

### a) Vagrant box implementation

LAMP stack machine is a Vagrant VM based on official Ubuntu Xenial image  
Vagrant file for setting up a new VM is present in [vagrant/Vagrantfile](vagrant/Vagrantfile)  
Vagrant VM provisioning shell script can be found in [vagrant/initvm.sh](vagrant/initvm.sh)   

Launch and connect to Vagrant box:
```
$ cd vagrant
$ vagrant up
$ vagrant ssh

login credentials
user: vagrant
pass: vagrant
```
Virtual machine IP address
```
192.168.33.10
```

#### Use Ansible to install the LAMP stack over Vagrant

Ansible playbooks for deploying the LAMP stack are in [ansible/install-lamp.yml](ansible/install-lamp.yml)

To deploy the LAMP stack, run:
```
$ cd ansible
$ ansible-playbook install-lamp.yml
```

### b) single docker image implementation

Easy route: use pre-made docker image and tweak it:  
https://github.com/ZopNow/docker-lamp-stack

Tweaked Dockerfile
```
FROM ubuntu:16.04

# APT package manager update and upgrade
RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y vim unzip wget curl

# Install PHP
RUN apt-get install -y \
    php7.0 \
    php7.0-cli \
    php7.0-mbstring \ 
    php7.0-zip \
    php7.0-dom \
    php7.0-curl \
    php7.0-mysql \
    composer

# Install Apache
RUN apt-get install -y apache2 libapache2-mod-php7.0
RUN a2enmod rewrite

# Install MySQL
RUN echo 'mysql-server mysql-server/root_password password password' | debconf-set-selections
RUN echo 'mysql-server mysql-server/root_password_again password password' | debconf-set-selections
RUN apt-get install -y mysql-client mysql-server

# Copy configurations
WORKDIR /var/www/application
COPY apache.config /etc/apache2/sites-available/000-default.conf
COPY index.php /var/www/application/public/
COPY start.sh /usr/bin/

# Publish Apache port
EXPOSE 80
# Publish MySQL port
EXPOSE 3306

# Entrypoint for docker
CMD ["/usr/bin/start.sh"]
```

Building the docker image
```
$ cd singledocker
$ docker build -t lamp .
```
Running the docker image
```
$ docker run --name=lamp -it -p 9980:80 -p 93360:3360 lamp
```

### c) docker-compose implementation for the whole stack

TODO: separate components into docker images and create the whole running "docker-compose up"

Component list:
- Apache web server + PHP installed and configured
- MySQL instance

### d) AWS E2C instance implementation

Can be provisioned for LAMP stack using Ansible playbooks in implementation a) Vagrant box
TODO: AWS account required

## Ruby application

### Part 1: Testing a drupal site (service level ping)

This is a web application implemented using Sinatra to test a Drupal site for response code/content.  

A site is considered live when:
- Returning HTTP status code 200 OK and  
- We can match some content to a pre-defined pattern

### Part 2: Bringing the site up/down

TODO: this needs access to AWS, using AWS SDK - unable to test

In the ruby application the following code is used to start an AWS instance:
```
require 'aws-sdk-ec2'  # v2: require 'aws-sdk'

def startinstance instancename
	ec2 = Aws::EC2::Resource.new(region: 'eu-central-1')
	i = ec2.instance(instancename)

	if i.exists?
		case i.state.code
		when 0
			# pending, do nothing (wait)
		when 16
			# already started
		when 48
			# terminated, can not start
		else
			i.start # stop it!
		end
	end
end

```
To stop an AWS instance:
```
require 'aws-sdk-ec2'  # v2: require 'aws-sdk'

def stopinstance instancename
	ec2 = Aws::EC2::Resource.new(region: 'eu-central-1')
	i = ec2.instance(instancename)

	if i.exists?
		case i.state.code
		when 48
			# terminated, do nothing
		when 64
			# stopping, do nothing (wait)
		when 80
			# stopped, again, do nothing
		else
			i.stop # stop it!
		end
	end
end

```
TODO: return codes, for every case




