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
![Bild von der Aufstellung](/Technische_Übersicht.drawio)


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
Das Vagrantfile sieht wie folgt aus

```ruby
Vagrant.configure("2") do |config|
    config.vm.define "docker" do |docker|
        docker.vm.box = "ubuntu/focal64"
        docker.vm.hostname = "docker01"
        docker.vm.network "private_network", ip: "192.168.50.2", auto_config: false
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
Nachdem das OS geladen wird, wie 

```shell
apt-get update
#Add Repository and GPG Key. Add Repo to sources
apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
#Update
apt-get update
#Install from Docker Repo and Install Docker
apt-cache policy docker-ce
sudo apt install docker-ce
```


### docker-compose.yaml File
Im Docker-Compose File werden die 3 Services und zugleich Portainer 

```yaml
version: '2'
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
     - /path/to/config:/config
     - /path/to/transcode:/transcode
     - /path/to/data/:/data
 
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
        - /path/to/data:/config
        - /path/to/tvseries:/tv #optional
        - /path/to/downloadclient-downloads:/downloads #optional
 
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
        - /path/to/data:/config
        - /path/to/movies:/movies #optional
        - /path/to/downloadclient-downloads:/downloads #optional
 
 portainer:
    image: portainer/portainer-ce
    container_name: portainer
    restart: unless-stopped
    ports:
        - 9000:9000
    command: -H unix:///var/run/docker.sock
    volumes:
        - /var/run/docker.sock:/var/run/docker.sock
        - /opt/portainer/data:/data
    network_mode: bridge
```


## Sicherheit


## Testing


## Bewertungsmatrix
In der nachstehende Tabelle wird das Bewertungsmatrix für die LB1 

| Kriterium                                                                             | Erfüllt |
| ------------------------------------------------------------------------------------- | ------- |
| Setup Umgebung, Lernumgebung, Tools (6P)                                              | Ja      |
| Technische Doku (Struktur, Tiefe, Gestaltung, Formatierung, Nachvollziehbarkeit) (6P) |         |
| Entwicklung des Repositories (Regelmässigkeit und Umfang der Updates/Commits) (3P)    |         |
| Grund-Service, Funktionalität, Dokumentation (Eigen- oder Ergänzungsleistung!) (3P)   |         |
| Ergänzende Services, Funktionalität, Dokumentation (3P)                               |         |
| Engagement, Haltung, Professionalität, Kommunikation (2P)                             |         |
| Präsentation, Live-Demo & Quellenangaben (2P)                                         |         |


## Quellen