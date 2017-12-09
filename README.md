# Implementing a Drupal hosting solution

In this three part document I will outline how to create a hosting platform for Drupal, deploy Drupal using automation, and I will write a simple ruby application to monitor the status of a Drupal website.

## Creating a LAMP stack machine 

In order to be able to host Drupal one needs a machine/VM/cloud instance with a running webserver, PHP interpreter, and a database backend.
Multiple ways to implement the hosting platform:
- Vagrant VM
- Single Docker image for the whole LAMP + Drupal stack
- Docker compose set of images running components of the stack

Components of the stack:
- Apache 2 web server
- PHP 7
- MySQL database
- Drupal

### Vagrant box implementation

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
Virtual machine IP address (default in the provided Vagrantfile)
```
192.168.33.10
```
IP address can be changed by editing the Vagrantfile [vagrant/Vagrantfile](vagrant/Vagrantfile)

#### Use Ansible to install the LAMP stack over Vagrant

Ansible playbooks for deploying the LAMP stack are in [ansible/install-lamp.yml](ansible/install-lamp.yml)

First edit Ansible inventory for your LAMP machine [ansible/inventory](ansible/inventory)

```
...

[lamp]
192.168.33.10 # <--- change this to your LAMP machine IP address
```

To deploy the LAMP stack, run the provided ansible playbook:
```
$ cd ansible
$ ansible-playbook install-lamp.yml
```

Comments on my playbook:
- python 2 is required for mysql modules
- pip is installed by the playbook
- mysql ansible module is installed by Ansible pip module

TODO: separate playbook functionality into roles

### Single docker image implementation

Create a custom Dockerfile for having a docker image containing the whole LAMP stack.

Tweaked Dockerfile [singledocker/Dockerfile](singledocker/Dockerfile)
```
TODO: embed dockerfile here
```

Building the docker image
```
$ cd singledocker
$ docker build -t lamp .
```
Running the docker image
```
$ docker run --name=lamp -it -p 9980:80 -p 93360:3360 lamp

this will run the docker image and publish the web service port on 9980 of the docker machine
```

### docker-compose implementation for the whole stack

TODO: separate components into docker images and create a whole stack instance using "docker-compose up"

Component list:
- Apache web server + PHP installed and configured
- MySQL instance

### AWS E2C instance implementation

The LAMP stack hosting machine can be an AWS E2C instance (t2.micro is free for testing).

Once the AWS E2C instance has been created using AWS web console one can use the Ansible playbook from the first section to deploy the LAMP stack on the machine.

TODO: AWS account, register, screenshots  


## Install Drupal from an Ansible playbook

*This is only applicable to the Vagrant and AWS implementation as single docker image implementation and docker compose implementation already incorporates the installation of Drupal to the docker image(s).*

TODO: work out this section

## Ruby application for monitoring a Drupal stack

### Part 1: Testing a drupal site (service level ping)

A RESTful ruby web application implemented using Sinatra to test a Drupal site for response code/content.  

A site is considered live when:
- HTTP GET request returns status code 200 OK
- We can match some content to a pre-defined pattern

### Part 2: Bringing the site up/down

If the service is runnig on AWS the provided ruby script can start/stop the instance  
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



# Links, references



- [Readme driven development](http://tom.preston-werner.com/2010/08/23/readme-driven-development.html)




