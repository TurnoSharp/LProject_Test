
#!bin/#!/usr/bin/env bash

echo "_________________________________"
echo "Tell the serial number of the VM:"
echo "_________________________________"
read n

#make directory for new VM and vagrant init
mkdir ./vagrant_vm$n
cd ./vagrant_vm$n
vagrant init

#add to .gitignore extra files
echo "/VMachines/vagrant_vm$n/.vagrant" >> /home/turnosharp/LProject_Test/.gitignore

#configure Vagrantfile
sed -i "12r ../config.vm.provision" ./Vagrantfile
sed -i "41c\config.vm.network "private_network", ip: "192.168.56.2$n""  ./Vagrantfile

#add ip new VM in ansible.inventory
cd /home/turnosharp/LProject_Test/IaC/ansible
echo "Server_VVM$n ansible_host=192.168.56.2$n" >> ./inventory
