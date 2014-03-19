# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

	config.vm.define "centos" do |centos|
		centos.vm.box = "centos"
		centos.vm.synced_folder "/sync", "/sync", create: true, type: "nfs"
		centos.vm.network "private_network", ip: "192.168.200.2"
		centos.vm.network "forwarded_port", guest: 80, host: 8080
		centos.vm.network "forwarded_port", guest: 443, host: 8443
		centos.vm.provider :virtualbox do |vb|
			vb.name = "centos"
		end
		centos.vm.provision :shell, :path => "centos_cfg/configure.sh"
	end

end
