VBoxManage list runningvms|awk '{print $2;}'|xargs -I vmid VBoxManage controlvm vmid poweroff

vagrant destroy base -f
rm -rf $HOME/VirtualBox\ VMs/base*
rm -rf $HOME/.vagrant.d/boxes/base
rm -rf .vagrant/machines/base

vagrant destroy laravel -f
rm -rf $HOME/VirtualBox\ VMs/laravel*
rm -rf $HOME/.vagrant.d/boxes/laravel
rm -rf .vagrant/machines/laravel
rm -rf output-virtualbox-iso
rm -f base.box

vagrant plugin install vagrant-vbguest
packer build config/base.json

vagrant box add base base.box
vagrant up base
vagrant halt base

rm -f base.box
VBoxManage list runningvms|awk '{print $2;}'|xargs -I vmid VBoxManage controlvm vmid poweroff
vagrant package base --output base.box

vagrant box add laravel base.box
vagrant up laravel
vagrant halt laravel

rm -f base.box
VBoxManage list runningvms|awk '{print $2;}'|xargs -I vmid VBoxManage controlvm vmid poweroff
