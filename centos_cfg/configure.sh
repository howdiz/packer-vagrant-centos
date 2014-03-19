mkdir /sync/conf.d
chmod 777 /sync/conf.d

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

mkdir /sync/mysql.data
chmod 777 /sync/mysql.data

cat <<EOF > /etc/my.conf
[mysqld]
datadir=/sync/mysql.data
socket=/var/lib/mysql/mysql.sock
user=mysql
symbolic-links=0
[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
EOF

chkconfig mysqld --add
chkconfig mysqld on --level 235
service mysqld start
mysql -e "GRANT ALL ON *.* TO 'root'@'%' WITH GRANT OPTION; UPDATE mysql.user SET Password = PASSWORD('vagrant') WHERE User='root'; FLUSH PRIVILEGES;"

chkconfig sendmail --add
chkconfig sendmail on --level 235
service sendmail start
