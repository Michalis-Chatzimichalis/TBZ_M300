apt-get update
apt-get upgrade -y
debconf-set-selections <<< 'mysql-server mysql-server/root_password password S3cr3tp4ssw0rd'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password S3cr3tp4ssw0rd'
apt install mysql-server
sudo sed -i -e"s/^bind-address\s*=\s*127.0.0.1/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
mysql -uroot -pS3cr3tp4ssw0rd <<%EOF%
	CREATE USER 'root'@'192.168.55.101' IDENTIFIED BY 'admin';
	GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.55.101';
	FLUSH PRIVILEGES;
%EOF%
service mysql restart