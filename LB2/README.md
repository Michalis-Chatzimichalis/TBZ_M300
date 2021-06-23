# Einleitung
In der LB2 werde ich mittels Docker einen Image einer einfachen Webapplikation erstellen und der dann über Container Orchestrierung (Kubernetes) automatisch bereitstellen. Andere Dienste, wie ein Anaylse Tool oder ein Reverse Proxy sind auch in Bearbeitung/Pilotphase.<br>
Mit diesem Befehl 
```shell
vagrant up
```

# Inhaltsverzeichnis
[1 - Technische Übersicht](#1---technische-übersicht)\
[2 - Voraussetzungen](#2---voraussetzungen)\
[3 - Funktionen](#3---funktionen)\
[4 - Deklarativer Aufbau](#4---deklarativer-aufbau)\
[5 - Kubernetes Orchestrierung](#5---kubernetes-orchestrierung)\
[5 - Sicherheit](#xx---sicherheit)\
[6 - Testing](#xx---testing)\
[7 - Reflexion](#xx---reflexion)\
[8 - Quellen](#xx---quellen)

--------

## 1 - Technische Übersicht
![Bild von der Aufstellung]()


## 2 - Voraussetzungen
Die Voraussetzungen fürs folgende Projekt sind folgende:

- GitHub
- Git/Bash
- Virtualbox (in diesem Fall MAAS der TBZ Cloud)
- Docker
  -  Kenntnisse von Vorteil
  -  Docker Hub Account
- Browser

## 3 - Funktionen
- Die node.js Applikation

## 4 - Deklarativer Aufbau
### 4.1 - Vorbereitung
Zuerst gehe ich auf WireGuard, um das VPN der TBZ-Cloud zu aktivieren. Danach gebe ich folgendes Befehl im Git/Bash ein.
```shell
ssh ubuntu@10.1.43.13
```
 Das Passwort finde ich heraus, wenn ich auf der HTTP-Seite des Servers gehe und unter **Accessing** die `data/.ssh/passwd-Datei` öffne, bekomme ich das Passwort.

Zuerst führe ich das um den Server zu aktualisieren
```shell
apt-get update && apt-get upgrade -y
```

### 4.2 - Docker Hub Konto anbinden
Mit diesem Befehl lege ich meinen Docker Hub Konto an und wird für mein Passwort gefordert.
```shell
docker login --username=michalis07
```
Bei erfolgreichem Anlegen kann ich ohne Hindernis Images auf Docker Hub hochzuladen ('pushen'). Der erfolgreicher Zugriff wird da dargestellt.<br> 
![Erfolgreicher Zugriff](/LB2/Bilder/Docker_Account_Erfolg.png)

Der Inhalt der Website ändere ich, indem ich 'nano /views/home.pug' eingebe und das HTML-Content anpassen.
![Content Änderung](/LB2/Bilder/Content_Änderung.png)

### 4.3 - Dockerfile
Das Dockerfile sieht wie folgt aus.
```dockerfile
FROM node:current-slim

LABEL MAINTAINER=marcello.calisto@tbz.ch

# Kopiere als erstes den Source-Code ins Verzeichns /src des Containers
COPY . /src

# Wechsle ins Verzeichnis /src und installiere da den NPM (Node Package Manager), welche alle Abhängigkeiten installiert
RUN cd /src; npm install

# Die App hört auf dem Port 8080
EXPOSE 8080

# Wechsle ins Verzeichnis /src und starte die App, wenn der Container gestartet wird
CMD cd /src && node ./app.js
```

Ich wechsle wieder im Home-Verzeichnis mit
```shell
cd .. 
docker image build -t michalis07/webapp:1.0 .
``` 
um das Image mit dem Repo-Name michalis07/webapp, mit dem Tag 1.0 und das Content, bzw. das Dockerfile vom jetzigen Verzeichnis zu nehmen.

Mit 
```shell
docker image push michalis07/webapp:1.0
```
lade ich das auf der Docker Hub unter mein Account hoch.![](/LB2/Bilder/Docker_Hub_Push.png)

### 4.4 - Docker Container starten
Das Docker Container starte ich mit und bekomme die SHA256 ID des Containers.
```shell
docker container run -d --name michalis-web -p 8080:8080 michalis07/webapp'
```
![](/LB2/Bilder/Docker_Web_App_Run.png)

Mit diesen beiden Varianten kann man den laufenden Container als Prozess ansehen. Der Zugriff auf die HTML-Seite erfolgt mit der URL `10.1.43.13:8080`.
```shell
docker ps | grep -i michalis-web
docker container ls | grep -i michalis-web
```

## 5 - Kubernetes Orchestrierung
Auf meinen lokalen Client (Host) installiere ich **KubeCTL**. Im Verzeichnis C:\Users\apoll\ erstelle ich den benötigten Ordner .kube und öffne CMD/GitBash, damit ich diesen Befehl in dem besagten Ordner eingeben kann. 
```shell
curl -LO https://dl.k8s.io/v1.21.0/bin/windows/amd64/kubectl.exe.sha256
```
Wenn die binäre Datei erfolgreich Danach gebe ich `kubectl.exe` im cmd rein und kubectl wird installiert.
Mit `kubectl version` kann die Version überprüft werden.

Nun erstelle ich den Verzeichnis **.kube** und wechsle zu dem, um die Konfigurationsdatei für das Kubernetes Cluster abzulegen, erstelle ich die leere Datei **config**.
Diesen Inhalt kopiere ich rein und speichere es ab.
```yml
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: [certificate-authority-key]
    server: [IP-Address:6443]
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: kubernetes-admin
  name: kubernetes-admin@kubernetes
current-context: kubernetes-admin@kubernetes
kind: Config
preferences: {}
users:
- name: kubernetes-admin
  user:
    client-certificate-data: [certificate-key]
    client-key-data: [key-key]
```

## XX - Sicherheit



## XX - Testing


## XX - Reflexion



## XX - Quellen
Die Beispielsaufgabe mit dem Node.js Applikation besteht von der GitLab Repository vom Marcello Calisto. [Link zur Repository](https://gitlab.com/ser-cal/Container-CAL-webapp_v1/-/tree/master/)