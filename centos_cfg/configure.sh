iptables -I INPUT -p tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp --dport 443 -j ACCEPT
iptables -I INPUT -p tcp --dport 3306 -j ACCEPT
service iptables save

mkdir /sync/conf.d > /dev/null 2>&1
chmod -R 777 /sync/conf.d
chmod -R g+s /sync/conf.d

cat <<EOF >> /etc/httpd/conf/httpd.conf
ServerName local:80
ServerName local:443
NameVirtualHost *:80
NameVirtualHost *:443
Include /sync/conf.d/*.conf
EOF

cat <<EOF > /sync/conf.d/local.conf
<VirtualHost *:80>
    DocumentRoot /sync
    ServerName local
    ErrorLog logs/error_log
    CustomLog logs/access_log common
    <Directory "/sync">
        Options All -Includes -ExecCGI -Indexes +MultiViews
        AllowOverride All
    </Directory>
    <Directory "/sync/conf.d">
        Order Deny,Allow
        Deny from All
    </Directory>
    <Directory "/sync/mysql.data">
        Order Deny,Allow
        Deny from All
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
    <Directory "/sync/conf.d">
        Order Deny,Allow
        Deny from All
    </Directory>
    <Directory "/sync/mysql.data">
        Order Deny,Allow
        Deny from All
    </Directory>
</VirtualHost>
EOF

chkconfig httpd --add
chkconfig httpd on --level 235
service httpd start

service mysqld start
mysql -e "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION; UPDATE mysql.user SET Password = PASSWORD('vagrant') WHERE User='root'; FLUSH PRIVILEGES;"
service mysqld stop

mkdir /sync/mysql.data > /dev/null 2>&1
if [ ! -d /sync/mysql.data/mysql ]; then
    rm -rf /sync/mysql.data/mysql
    mv /var/lib/mysql/mysql /sync/mysql.data
fi
chmod -R 777 /sync/mysql.data
chmod -R g+s /sync/mysql.data
chown -R mysql:mysql /sync/mysql.data
ln -s /sync/mysql.data /var/lib/mysql

cat <<EOF > /etc/my.cnf
[mysqld]
datadir=/sync/mysql.data
socket=/sync/mysql.data/mysql.sock
user=mysql
symbolic-links=0
[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
EOF

chkconfig mysqld --add
chkconfig mysqld on --level 235
service mysqld start

chkconfig sendmail --add
chkconfig sendmail on --level 235
service sendmail start

echo "127.0.0.1 local" >> /etc/hosts

echo "Welcome, Vagrant." > /etc/motd
