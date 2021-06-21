# Einleitung
In der LB2 werde ich 
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
![Bild von der Aufstellung]()


## 2 - Voraussetzungen
Die Voraussetzungen fürs folgende Projekt sind folgende:

- GitHub
- Git/Bash
- Vagrant (Vagrantfile)
- Virtualbox
- Docker (Docker-File, Kenntnisse von Vorteil)
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
Bei erfolgreichem Anlegen kann ich ohne Hindernis Images auf Docker Hub hochzuladen ('pushen'). Der erfolgreicher Zugriff wird da dargestellt. ![Erfolgreicher Zugriff](/LB2/Bilder/Docker_Account_Erfolg.png)

Der Inhalt der Website ändere ich, indem ich 'nano /views/home.pug' eingebe und das HTML-Content anpassen. ![Content Änderung](/LB2/Bilder/Content_Änderung.png)

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

### 4.3 - Docker Container starten
Das Docker Container starte ich mit;
```shell
docker container run -d --name michalis-web -p 8080:8080 michalis07/webapp'
```
![](/LB2/Bilder/Docker_Web_App_Run.png).

Mit  kann man den laufenden Container als Prozess ansehen. Der Zugriff auf die HTML-Seite erfolgt mit der URL '10.1.43.13:8080'.
```shell
docker ps | grep -i michalis-web
docker container ls | grep -i michalis-web
```


### 4.4 - Dockerfile
Das Dockerfile sieht wie folgt aus.
```docker
FROM node:current-slim

LABEL MAINTAINER=marcello.calisto@tbz.ch

# Kopiere als erstes den Source-Code ins Verzeichns /src des Containers
COPY . /src

# Wechsle ins Verzeichnis /src und installiere da die App und ihre Dependencies des containers
RUN cd /src; npm install

# Die App "horcht" auf folgendem Port
EXPOSE 8080

# Wechsle ins Verzeichnis /src und starte die App, wenn der Container gestartet wird
CMD cd /src && node ./app.js
```



## 5 - Sicherheit



## 6 - Testing


## 7 - Reflexion

## 8 - Quellen
Die Beispielsaufgabe mit dem Node.js Applikation besteht von der GitLab Repository vom Marcello Calisto. [Link zur Repository](https://gitlab.com/ser-cal/Container-CAL-webapp_v1/-/tree/master/)