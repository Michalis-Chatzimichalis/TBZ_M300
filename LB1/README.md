# Einleitung
In der LB1 werde ich Docker verwenden, um Plex einzurichten und mittels Sonarr/Radarr ein automatisiertes Herunterladen von TV-Serien und Filme gestatten.

# Inhaltsverzeichnis
1. Technische Übersicht
2. Voraussetzungen
3. Deklaritiver Aufbau
4. Funktionen
5. Sicherheit
6. Testing
7. Bewertungsmatrix
8. Quellen

## Technische Übersicht
![Bild von der Aufstellung](/LB1/Bilder/Technische_Übersicht.png)


## Voraussetzungen
- GitHub
- Git/Bash
- Vagrant (Vagrantfile)
- Virtualbox
- Docker (Docker-File, Kenntnisse von Vorteil)
- Browser

## Funktionen
- Der Plex Server dient für das Herausgeben und Zuschauen von Inhalte. Der Link zum [Plex-Server Container (mit IP)](http://192.168.50.2:32400). Der [Link](www.plex.tv) zur offiziellen Programm von Plex.
- Der Sonarr Dienst bietet die Möglichkeit Dateiindexinformationen (Torrent-Websites) automatisch an Ihren Download-Client (z. B. Utorrent/qTorrent) zu übergeben und dann Aktionen mit den heruntergeladenen Dateien durchzuführen.
- Der Radarr Dienst dient für das 

## Deklaritiver Aufbau
### Vagrantfile
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

### Bash-File um Docker zu installieren
Nachdem die VM und die Netzwerkkonfigurationen eingerichtet werden, wird dieses Shell-Script eingespiest, welches das System allererstens aktualisiert und danach die nötigen Komponenten für die Docker Engine Installation ladet. Zuletzt fügt es den automatisch erstellten Vagrant User in der Docker-Gruppe sodass der Vagrant-User auch ohne sudo Präfix die Docker-Kommandos ausführen kann. Am Schluss wechselts im gemounten Verzeichnis und startet die 4 Container, die im untenstehenden yaml-File beschrieben sind.

```shell
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
```

### docker-compose.yml File
Im Docker-Compose File werden die 3 Services und zugleich Portainer eingerichtet und mit dem docker-compose up -d Befehl gestartet.

```yml
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
     - TZ=Europe/UTC
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
        - TZ=Europe/UTC
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
        - TZ=Europe/UTC
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
    #command: -H unix:///var/run/docker.sock
    volumes:
        - /portainer/data:/data
    network_mode: bridge
```

Die Dienste sind demnach unter localhost:32400 für Plex, für radarr localhost:7878 usw. erreichbar.

## Sicherheit
Die Ports die weitergeleitet werden sollen, sind dieselbe, die der Docker Daemon weiterleiten tut und zwar sind es die 9


## Testing
Der erster Zugriff auf die Dienste habe ich erfolgreich nach der Portweiterleitung ausgestestet. Die URL-Adresse wäre localhost:[Port]. Dieses [Video]](/LB1/media/downloads/Erster_Zugriff_auf_Dienste.mp4) stellt den Zugriff dar.


## Bewertungsmatrix
In der nachstehende Tabelle wird das Bewertungsmatrix für die LB1.

| Kriterium                                                                             | Erfüllt                                                         |
| ------------------------------------------------------------------------------------- | --------------------------------------------------------------- |
| Setup Umgebung, Lernumgebung, Tools (6P)                                              | Ja                                                              |
| Technische Doku (Struktur, Tiefe, Gestaltung, Formatierung, Nachvollziehbarkeit) (6P) |                                                                 |
| Entwicklung des Repositories (Regelmässigkeit und Umfang der Updates/Commits) (3P)    | Ja, 41 Commits über 1 Monat                                     |
| Grund-Service, Funktionalität, Dokumentation (Eigen- oder Ergänzungsleistung!) (3P)   | Ja, mit Docker Container und Services (KEIN Vorhander Beispiel) |
| Ergänzende Services, Funktionalität, Dokumentation (3P)                               |                                                                 |
| Engagement, Haltung, Professionalität, Kommunikation (2P)                             | IMO andere geholfen,                                            |
| Präsentation, Live-Demo & Quellenangaben (2P)                                         |                                                                 |

## Reflexion
Meiner Meinung nach war diese LB1 eine gute Übung für mich, da ich mich im Vorhin nicht so wirklick mit Vagrant ausgekennt habe. Nun könnte ich eine automatisierte Instanz 4 verschiedener Docker Containers zustande bringen, was mich sehr motiviert. Die Dokumentation mit Git war auch einer interessanter Aspekt und konnte mir jedenfalls wichtige Sachen entnehmen. Eine Sache war, dass GitHub eine max. Dateigrösse auf 100MB setzt und wenn man das nicht beachtet und einige lokale Commits mit einem grösseren File absichert und den File danach löscht, ist der Push zur Remote-Repository sehr schwierig. Mit git revert/checkout und das git LFS Modul kam ich nicht weiter und müsste meine Remote-Repo nochmals in einem anderen lokalen Verzeichnis pullen und dort denn Stand weitertreiben.

## Quellen
Die config.xml-Files in den Verzeichnissen habe ich von [diesem GitHub](https://github.com/shaharyarahmad/media-setup)