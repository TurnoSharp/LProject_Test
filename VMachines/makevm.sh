
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
#cp ssh_pub_key in vm on first boot
sed -i "12r ../config.vm.provision" ./Vagrantfile
#create config.vm.network
vfvmip=$(echo config.vm.network \"private_network\", ip: \"192.168.56.2$n\")
sed -i "41c\ $vfvmip"  ./Vagrantfile

#add ip new VM in ansible.inventory
echo "Server_VVM$n ansible_host=192.168.56.2$n" >> /home/turnosharp/LProject_Test/IaC/ansible/inventory/hosts
