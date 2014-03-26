VBoxManage list runningvms|awk '{print $2;}'|xargs -I vmid VBoxManage controlvm vmid poweroff
vagrant destroy base -f
rm -rf $HOME/VirtualBox\ VMs/base*
rm -rf $HOME/.vagrant.d/boxes/base
rm -rf .vagrant/machines/base
rm -rf output-virtualbox-iso
rm -f base.box
vagrant plugin install vagrant-vbguest
packer build config/base.json
vagrant box add base base.box
vagrant up base
vagrant ssh base
