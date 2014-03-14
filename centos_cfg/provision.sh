sed -i "s/^.*requiretty/#Defaults requiretty/" /etc/sudoers

date > /etc/vagrant_box_build_time

yum -y install wget

mkdir -pm 700 /home/vagrant/.ssh
wget --no-check-certificate 'https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub' -O /home/vagrant/.ssh/authorized_keys
chmod 0600 /home/vagrant/.ssh/authorized_keys
chown -R vagrant:vagrant /home/vagrant/.ssh

yum -y install nfs-utils nano httpd mysql mysql-server php php-mysql php-gd php-xml php-mbstring
yum -y clean all

iptables -I INPUT -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -p tcp --dport 3306 -j ACCEPT
service iptables save

cat <<EOF >> /etc/httpd/conf/httpd.conf
ServerName local:80
ServerName local:443
NameVirtualHost *:80
NameVirtualHost *:443
Include /sync/conf.d/*.conf
EOF

cat <<EOF > /etc/httpd/conf.d/local.conf
<VirtualHost *:80>
    DocumentRoot /sync
    ServerName local
    ErrorLog logs/error_log
    CustomLog logs/access_log common
    <Directory "/sync">
        Options All -Includes -ExecCGI -Indexes +MultiViews
        AllowOverride All
    </Directory>
</VirtualHost>
<VirtualHost *:443>
    DocumentRoot /sync
    ServerName local
    ErrorLog logs/error_log
    CustomLog logs/access_log common
    <Directory "/sync">
        Options All -Includes -ExecCGI -Indexes +MultiViews
        AllowOverride All
    </Directory>
</VirtualHost>
EOF

service httpd start
chkconfig httpd on

service mysqld start
mysql -e "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION; UPDATE mysql.user SET Password = PASSWORD('vagrant') WHERE User='root'; FLUSH PRIVILEGES;"
chkconfig mysqld on

echo "127.0.0.1 local" >> /etc/hosts

echo "Welcome, Vagrant." > /etc/motd
