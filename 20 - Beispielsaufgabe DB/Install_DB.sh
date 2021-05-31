sudo apt-get update && sudo apt-get upgrade -y
sudo apt install apache2 -y
sudo apt install debconf-utils -y
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password Admin1234!'
sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again Admin1234!'
sudo apt-get -y install php libapache2-mod-php php-curl php-cli php-mysql php-gd mysql-client mysql-server 
# Admininer SQL UI 
sudo mkdir /usr/share/adminer
sudo wget "http://www.adminer.org/latest.php" -O /usr/share/adminer/latest.php
sudo ln -s /usr/share/adminer/latest.php /usr/share/adminer/adminer.php
echo "Alias /adminer.php /usr/share/adminer/adminer.php" | sudo tee /etc/apache2/conf-available/adminer.conf
sudo a2enconf adminer.conf
sudo service apache2 restart