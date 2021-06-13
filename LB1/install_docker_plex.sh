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
usermod -aG docker vagrant
#docker-compose up
cd /vagrant
docker-compose up -d