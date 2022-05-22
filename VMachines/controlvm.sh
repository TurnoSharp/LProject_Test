
#!/#!/usr/bin/env bash

green='\e[32m]'
red='\e[31m]'
bgblue='\033[44m'
bgred='\033[41m'
white='\033[1;37m'
clear='\e[0m'
vagrant_vm1=/home/turnosharp/LProject_Test/VMachines/vagrant_vm1
vagrant_vm2=/home/turnosharp/LProject_Test/VMachines/vagrant_vm2
vagrant_vm3=/home/turnosharp/LProject_Test/VMachines/vagrant_vm3

ColorGreen(){
	echo -ne $green$1$clear
}

BackgroundBlue(){
	echo -ne $bgblue$white$1$clear
}

BackgroundRed(){
  echo -ne $bgred$white$1$clear
}

up_vm(){
  BackgroundBlue '=====Start vagrant VM on this machine====='
  echo ""
  cd $vagrant_vm1
  echo ""
  BackgroundBlue '__________/Start VVM1\__________'
  echo ""
  vagrant up
  cd $vagrant_vm2
  echo ""
  BackgroundBlue '__________/Start VVM2\__________'
  echo ""
  vagrant up
  cd $vagrant_vm3
  echo ""
  BackgroundBlue '__________/Start VVM3\__________'
  echo ""
  vagrant up
}

down_vm(){
  BackgroundRed '=====Stop vagrant VM on this machine====='
  echo ""
  cd $vagrant_vm1
  echo ""
  BackgroundRed '__________/Stop VVM1\__________'
  echo ""
  vagrant halt
  cd $vagrant_vm2
  echo ""
  BackgroundRed '__________/Stop VVM2\__________'
  echo ""
  vagrant halt
  cd $vagrant_vm3
  echo ""
  BackgroundRed '__________/Stop VVM3\__________'
  echo ""
  vagrant halt
}

global_status(){
  BackgroundBlue '|Status VM throughout the system|'
  echo ""
  vagrant global-status
  BackgroundBlue '|_______________________________|'
}

box_list(){
  BackgroundBlue '|Vagrant Box List|'
  echo ""
  vagrant box list
  BackgroundBlue '|________________|'
}

check_directory(){
  BackgroundBlue '|Check VM directory|'
  echo ""
  ls -l
  BackgroundBlue '|__________________|'
}

make_vm(){
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
  cd ..
}

menu(){
  echo -ne "
  $(ColorGreen 'Control vagrant VM')
  $(ColorGreen '1)') Start VM
  $(ColorGreen '2)') Stop VM
  $(ColorGreen '3)') create new VM
  $(ColorGreen '4)') Check VM directory
  $(ColorGreen '5)') Global Status
  $(ColorGreen '6)') Box list
  $(ColorGreen '0)') Exit
  "

read a
  case $a in
    1) up_vm; menu;;
    2) down_vm; menu;;
    3) make_vm; menu;;
    4) check_directory; menu;;
    5) global_status; menu;;
    6) box_list; menu;;
    0) exit 0;;
  esac
}

menu
