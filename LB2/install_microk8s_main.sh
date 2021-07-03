#Set time and do a starting update -> upgrade
sudo rm /etc/localtime && sudo ln -s /usr/share/zoneinfo/Europe/Zurich /etc/localtime
apt-get update
apt-get upgrade -y
#Set Debug
set -o xtrace
#Install Microk8s über SNAP    
snap install microk8s --classic
usermod -a -G microk8s vagrant
microk8s enable dns
#Make Directory .kube in Vagrant Home, put microk8s config in there and change own rights to vagrant
mkdir -p /home/vagrant/.kube
microk8s config >/home/vagrant/.kube/config
chown -f -R vagrant:vagrant /home/vagrant/.kube
#Install kube command line tools
snap install kubectl --classic
microk8s kubectl apply -f https://raw.githubusercontent.com/mc-b/duk/master/addons/dashboard-skip-login-no-ingress.yaml