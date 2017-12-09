#!/bin/bash
#
# shell provisioning for Vagrant box by adamkov (c) 2017
#

NEWUID="3999"
USERNAME="vagrant"

echo setting up passwordless sudo
sed -i 's,%sudo\tALL=(ALL:ALL) ALL,%sudo ALL=(ALL:ALL) NOPASSWD:ALL,' /etc/sudoers

echo adding user $USERNAME with id $NEWUID
useradd -u $NEWUID -G sudo,admin,adm -r -m -p '$1$O8gcCqt4$Eusxxbmp20HDBjEROpipU0' $USERNAME

echo copy ssh key over
mkdir -p /home/$USERNAME/.ssh
cp /home/ubuntu/.ssh/authorized_keys /home/$USERNAME/.ssh/authorized_keys
chown -R $USERNAME:$USERNAME /home/$USERNAME/.ssh

# install python
apt-get update
apt-get install -y python
