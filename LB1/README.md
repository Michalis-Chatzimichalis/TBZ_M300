# Einleitung
In der LB1 werde ich Docker verwenden, um Plex einzurichten und mittels Sonarr/Radarr ein automatisiertes Herunterladen von TV-Serien und Filme gestatten. Mit dem folgenden Kommando könnte Ihr die VM bei euch einrichten, um die 4 Container mit einer Absicherung mittels UFW hochzufahren.
```shell
vagrant up
```

# Inhaltsverzeichnis
[1 - Technische Übersicht](#1---technische-übersicht)\
[2 - Voraussetzungen](#2---voraussetzungen)\
[3 - Funktionen](#3---funktionen)\
[4 - Deklarativer Aufbau](#4---deklarativer-aufbau)\
[5 - Sicherheit](#5---sicherheit)\
[6 - Testing](#6---testing)\
[7 - Reflexion](#7---reflexion)\
[8 - Quellen](#8---quellen)

--------

## 1 - Technische Übersicht
![Bild von der Aufstellung](/LB1/Bilder/Technische_Übersicht.png)


## 2 - Voraussetzungen
Die Voraussetzungen fürs folgende Projekt sind folgende:

- GitHub
- Git/Bash
- Vagrant (Vagrantfile)
- Virtualbox
- Docker (Docker-File, Kenntnisse von Vorteil)
- Browser

## 3 - Funktionen
- Der Plex Server dient für das Herausgeben und Zuschauen von Inhalte. Der Link zum [Plex-Server Container (mit IP)](http://192.168.50.2:32400). Der [Link](www.plex.tv) zur offiziellen Programm von Plex.
- Der Sonarr Dienst bietet die Möglichkeit Dateiindexinformationen (Torrent-Websites) automatisch an Ihren Download-Client (z. B. Utorrent/qTorrent) zu übergeben und dann Aktionen mit den heruntergeladenen Dateien durchzuführen. [Link](localhost:8989)
- Radarr verlässt sich auf RSS-Feeds, um das Greifen von Veröffentlichungen zu automatisieren, sobald diese veröffentlicht werden, sowohl für neue Veröffentlichungen als auch für bereits veröffentlichte Veröffentlichungen, die neu oder erneut veröffentlicht werden. [Link](localhost:7878)
- Portainer dient für die Verwaltung von den 3 Container. [Link](localhost:9000)

## 4 - Deklarativer Aufbau
### 4.1 - Vagrantfile
Das Vagrantfile sieht wie folgt aus. Am Anfang wird die Variable für das Definieren der VM-Einstellungen angegeben. Mit docker.vm.xxxxx

```ruby
Vagrant.configure("2") do |config|
    config.vm.define "docker" do |docker|
        docker.vm.box = "ubuntu/focal64"
        docker.vm.hostname = "docker01"
        docker.vm.network "private_network", ip: "192.168.50.2"
        docker.vm.network "forwarded_port", guest: 8989, host: 8989
        docker.vm.network "forwarded_port", guest: 7878, host: 7878
        docker.vm.network "forwarded_port", guest: 9000, host: 9000
        docker.vm.network "forwarded_port", guest: 8000, host: 8000
        docker.vm.network "forwarded_port", guest: 32400, host: 32400
        docker.vm.network "forwarded_port", guest: 3005, host: 3005
        docker.vm.network "forwarded_port", guest: 8324, host: 8324
        docker.vm.network "forwarded_port", guest: 32469, host: 32469
        docker.vm.network "forwarded_port", guest: 1900, host: 1900, protocol: "udp"
        docker.vm.network "forwarded_port", guest: 32410, host: 32410, protocol: "udp"
        docker.vm.network "forwarded_port", guest: 32412, host: 32412, protocol: "udp"
        docker.vm.network "forwarded_port", guest: 32413, host: 32413, protocol: "udp"
        docker.vm.network "forwarded_port", guest: 32414, host: 32414, protocol: "udp"
        docker.vm.provision "shell", path: "install_docker_plex.sh"
        docker.vm.provider "virtualbox" do |vb|
            vb.customize [
                "modifyvm", :id,
                "--memory", 1024,
                "--cpus", 1,
                "--name", "M300_LB1_Docker_Plex",
            ]
        end
    end
end
```

### 4.2 - Bash-File um Docker zu installieren
Nachdem die VM und die Netzwerkkonfigurationen eingerichtet werden, wird dieses Shell-Script eingespiest, welches das System allererstens aktualisiert und danach die nötigen Komponenten für die Docker Engine Installation ladet. Zuletzt fügt es den automatisch erstellten Vagrant User in der Docker-Gruppe sodass der Vagrant-User auch ohne sudo Präfix die Docker-Kommandos ausführen kann. Am Schluss wechselts im gemounten Verzeichnis und startet die 4 Container, die im untenstehenden yaml-File beschrieben sind.

```shell
#Set time and do a starting update -> upgrade
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
echo "y" | sudo ufw enable
#UFW for Plex
sudo ufw allow from 10.0.2.2 to any port 22
sudo ufw allow 3005/tcp
sudo ufw allow 8324/tcp
sudo ufw allow 32400/tcp
sudo ufw allow 32469/tcp
sudo ufw allow 1900/udp
sudo ufw allow 32410:32413/udp
#UFW for Sonarr, Radarr, Portainer
sudo ufw allow 7878/tcp
sudo ufw allow 8000/tcp
sudo ufw allow 8989/tcp
sudo ufw allow 9000/tcp
#docker-compose up
docker-compose up -d
```

### 4.3 - docker-compose.yml File
Im Docker-Compose File werden die 3 Services und zugleich Portainer eingerichtet und mit dem docker-compose up -d Befehl gestartet. Die Container werden der Reihe nach gestartet, bzw. das definierte Image wird vom Docker Hub geholt und danach mit den nötigen Ports und Environment-Variabeln gestartet. Die Environment-Variables sind mehrheitlich Systemanpassungen wie die Zeit

```yaml
version: '3'
services:
 plex:
   container_name: plex
   image: plexinc/pms-docker
   restart: unless-stopped
   ports:
     - 32400:32400/tcp
     - 3005:3005/tcp
     - 8324:8324/tcp
     - 32469:32469/tcp
     - 1900:1900/udp
     - 32410:32410/udp
     - 32412:32412/udp
     - 32413:32413/udp
     - 32414:32414/udp
   environment:
     - TZ=Europe/Zurich
     - PLEX_CLAIM=Z4szTvSYzN7tfjEsUyDz
     - ADVERTISE_IP=http://192.168.50.2:32400/
   hostname: Vagrant_VM
   volumes:
     - /config/plex:/config
     - /media:/data
     - /config/plex/transcode
 
 sonarr: 
    container_name: sonarr
    image: linuxserver/sonarr
    restart: unless-stopped
    ports:
        - 8989:8989/tcp
    environment:
        - TZ=Europe/Zurich
        - PGID=1000
        - PUID=1000
    volumes:
        - /config/sonarr:/config
        - /media/series:/tv
        - /media/downloads:/downloads
 
 radarr: 
    container_name: radarr
    image: linuxserver/radarr
    restart: unless-stopped
    ports:
        - 7878:7878/tcp
    environment:
        - TZ=Europe/Zurich
        - PGID=1000
        - PUID=1000
    volumes:
        - /config/radarr:/config
        - /media/movies:/movies
        - /media/downloads:/downloads
 
 portainer:
    image: portainer/portainer-ce
    container_name: portainer
    restart: unless-stopped
    ports:
        - 9000:9000
    command: -H unix:///var/run/docker.sock
    volumes:
        - /portainer/data:/data
        - /var/run/docker.sock:/var/run/docker.sock
    network_mode: bridge
```

Die Dienste sind demnach unter localhost:32400 für Plex, für radarr localhost:7878 usw. erreichbar.

## 5 - Sicherheit
Die Ports die weitergeleitet werden sollen, sind dieselbe, die der Docker Daemon weiterleiten tut und zwar sind es die 9. Auf der Ubuntu VM habe/werde ich die UFW einsetzen, um nur die Ports an meinem lokalen Host weiterzuleiten sowie an den Docker Containers freizugeben. SSH Zugriff habe ich auch nur auf meinem Host eingegrenzt `sudo ufw allow from 10.0.2.2 to any port 22`.


## 6 - Testing
Der erster Zugriff auf die Dienste habe ich erfolgreich nach der Portweiterleitung ausgestestet. Die URL-Adresse wäre localhost:[Port]. Dieses [Video](/LB1/media/downloads/Zugriff.gif) stellt den Zugriff dar.\
Der Zugriff auf Plex und der Login mit dem vordefinierten Claim-Token, den mit meinem Account verbunden ist, war erfolgreich und ich sehe meine Plex-Inhalte, die mit meinem Account verbunden sind. \
Das Login auf Portainer war ebenfalls erfolgreich. Bei Sonarr und Radarr habe ich keine zusätzliche Konfiguration getätigt.

## 7 - Reflexion
Meiner Meinung nach war diese LB1 eine gute Übung für mich, da ich mich im Vorhin nicht so wirklick mit Vagrant ausgekennt habe. Nun könnte ich eine automatisierte Instanz 4 verschiedener Docker Containers zustande bringen, was mich sehr motiviert. Die Dokumentation mit Git war auch einer interessanter Aspekt und konnte mir jedenfalls wichtige Sachen entnehmen.\
Eine Sache war, dass GitHub eine max. Dateigrösse auf 100MB setzt und wenn man das nicht beachtet und einige lokale Commits mit einem grösseren File absichert und den File danach löscht, ist der Push zur Remote-Repository sehr schwierig. Mit git revert/checkout und das git LFS Modul kam ich nicht weiter und müsste meine Remote-Repo nochmals in einem anderen lokalen Verzeichnis pullen und dort denn Stand weitertreiben.

## 8 - Quellen
Die config.xml-Files in den Verzeichnissen habe ich von [diesem GitHub](https://github.com/shaharyarahmad/media-setup).