VBoxManage list runningvms|awk '{print $2;}'|xargs -I vmid VBoxManage controlvm vmid poweroff
vagrant destroy centos -f
rm -rf $HOME/VirtualBox\ VMs/centos
rm -rf $HOME/.vagrant.d/boxes/centos
rm -rf .vagrant/machines/centos
vagrant plugin install vagrant-vbguest
packer build centos.json
vagrant box add centos centos.box
vagrant up centos
vagrant ssh centos
