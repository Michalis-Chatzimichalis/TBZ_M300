sudo rm /etc/localtime && sudo ln -s /usr/share/zoneinfo/Europe/Zurich /etc/localtime
apt-get update
apt-get upgrade -y
#Add Repository and GPG Key. Add Repo to sources
apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
#Update
apt-get update
apt-get upgrade -y
#Install from Docker Repo and Install Docker
apt-cache policy docker-ce
apt install docker-ce -y
apt install docker-compose -y
#Add Vagrant in Docker Group so no sudo, cd into shared folder
usermod -aG docker vagrant
cd /vagrant
#UFW enablen
echo "y" | sudo ufw disable
#UFW for Plex
#sudo ufw allow from 10.0.2.2 to any ssh
sudo ufw allow 32400/tcp
sudo ufw allow 3005/tcp
sudo ufw allow 8324/tcp
sudo ufw allow 32469/tcp
sudo ufw allow 1900/udp
sudo ufw allow 32410/udp
sudo ufw allow 32412/udp
sudo ufw allow 32413/udp
sudo ufw allow 32413/udp
#UFW for Sonarr, Radarr, Portainer
sudo ufw allow 8989/tcp
sudo ufw allow 7878/tcp
sudo ufw allow 9000/tcp
sudo ufw allow 8000/tcp
#docker-compose up
docker-compose up -d