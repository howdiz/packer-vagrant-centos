packer-vagrant-centos
==========

inspired by:
https://github.com/kentaro/packer-centos-template

`sh build_all.sh`

**Packer** will:

* obtain CentOS from one of the mirrors specified in **base.json**
* execute anaconda according to **kickstart.cfg**
* install a base CentOS system on top of that minimal kernel
* run **provision.sh** on first boot to establish a web application stack

**Vagrant** will:

* install VirtualBox Guest Additions plugin
* clone a VirtualBox image from the system created by Packer
* set up a private network with ip address **192.168.200.2**
* forward port **80** to **8080** and port **443** to **8443**

Vital features of **provision.sh**:

* create '**root**' user with password '**vagrant**'
* obtain **Remi** and **EPEL** repository database information
* install server daemons -- **NFS**, **Apache**, **MySQL**, **Sendmail**
* install **PHP** w/ extensions **mysql** **gd** **xml** **mbstring** **mcrypt**

On first boot **setup.sh** adds:

* iptables configuration -- granting 'outside' access to ports **80**, **443** and **3306**
* creation of default **VirtualHost**
* creation of 'vanilla' **my.cnf** for MySQL
* grant of **MySQL** user '**root**' with password '**vagrant**' with broadest privileges

Connectivity to VM's servers, **from Host**:

* add to /etc/hosts -- `192.168.200.2 local`
* NFS-sync'd folder created by vagrant -- `/sync`
* database -- `mysql -h192.168.200.2 -uroot -pvagrant`

To add an *additional* Apache **VirtualHost**:

* add to /etc/hosts -- `192.168.200.2 example.local`
* vhost configuration -- `/sync/conf.d/example.local.conf`
* `vagrant ssh centos`
* `sudo service httpd restart`

To the above, **laravel.sh** adds:

* **composer** and **laravel**
* additional vhost -- `/sync/conf.d/laravel.local.conf`
* base install of laravel -- `/sync/laravel`
* fully updated `vendor/` packages

`sh up_base.sh`

**OR**

`sh up_laravel.sh`
