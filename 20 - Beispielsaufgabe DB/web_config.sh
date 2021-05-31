apt-get update
apt-get -y install debconf-utils apache2 nmap
debconf-set-selections <<< 'mysql-server mysql-server/root_password password S3cr3tp4ssw0rd'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password S3cr3tp4ssw0rd'
apt-get -y install php libapache2-mod-php php-curl php-cli php-mysql php-gd mysql-client
mkdir /usr/share/adminer
wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php
ln -s /usr/share/adminer/latest.php /usr/share/adminer/adminer.php
echo "Alias /adminer.php /usr/share/adminer/adminer.php" |  tee /etc/apache2/conf-available/adminer.conf
a2enconf adminer.conf 
service apache2 restart 
echo '127.0.0.1 localhost web01\n192.168.55.100 db01' > /etc/hosts