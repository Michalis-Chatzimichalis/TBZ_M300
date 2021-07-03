#Set time and do a starting update -> upgrade
sudo rm /etc/localtime && sudo ln -s /usr/share/zoneinfo/Europe/Zurich /etc/localtime
apt-get update
apt-get upgrade -y
#Set Debug
set -o xtrace
#Install Microk8s über SNAP  
snap install microk8s --classic
#Add Private Key into Master-Node (IP: 192.168.100.10)
echo $(ssh -i /vagrant/.vagrant/machines/main/virtualbox/private_key -o StrictHostKeyChecking=no vagrant@192.168.100.10 "sudo microk8s add-node | grep 192.168.100.10") >/tmp/join
bash -x /tmp/join