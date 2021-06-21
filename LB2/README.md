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
Zuerst gehe ich auf WireGuard, um das VPN der TBZ-Cloud zu aktivieren. Danach gebe ich 'ssh ubuntu@10.1.43.13' im Git/Bash ein und verbinde ich mich auf meinem definierten Server. Das Passwort finde ich heraus, wenn ich auf der HTTP-Seite des Servers gehe und unter **Accessing** die 'data/.ssh/passwd-Datei' öffne, bekomme ich das Passwort.

Zuerst führe ich ein 'apt-get update && apt-get upgrade -y' aus um den Server zu aktualisieren.

**Docker Hub Konto anbinden**<br>
Mit 'docker login --username=michalis07' und mein Passwort lege ich meine Docker Accountdaten hinter, um ohne Hindernis Images auf Docker Hub hochzuladen ('pushen'). Der erfolgreicher Zugriff wird da dargestellt. ![Erfolgreicher Zugriff](/LB2/Bilder/Docker_Account_Erfolg.png)

Der Inhalt der Website ändere ich, indem ich 'nano /views/home.pug' eingebe und das HTML-Content anpassen. ![Content Änderung](/LB2/Bilder/Content_Änderung.png)

Ich wechsle wieder im Home-Verzeichnis mit 'cd ..' und gebe 'docker image build -t michalis07/webapp:1.0 .' um das Image mit dem Repo-Name michalis07/webapp, mit dem Tag 1.0 und das Content, bzw. das Dockerfile vom jetzigen Verzeichnis zu nehmen.

Mit 'docker image push michalis07/webapp:1.0' lade ich das auf der Docker Hub unter mein Account hoch.![](/LB2/Bilder/Docker_Hub_Push.png)

**Docker Container Run**
Das Docker Container starte ich mit 'docker container run -d --name michalis_web -p 8080:8080 michalis07/webapp'. ![](/LB2/Bilder/Docker_Web_App_Run.png).

Mit 'docker ps | grep -i michalis' kann man den laufenden Container als Prozess ansehen. DEr Zugriff auf die HTML-Seite erfolgt mit der URL '10.1.43.13:8080'.


### 4.2 - Dockerfile
Das Vagrantfile sieht wie folgt aus. Am Anfang wird die Variable für das Definieren der VM-Einstellungen angegeben. Mit docker.vm.xxxxx

## 5 - Sicherheit
Die Ports die weitergeleitet werden sollen, sind dieselbe, die der Docker Daemon weiterleiten tut und zwar sind es die 9. Auf der Ubuntu VM habe/werde ich die UFW einsetzen, um nur die Ports an meinem lokalen Host weiterzuleiten sowie an den Docker Containers freizugeben. SSH Zugriff habe ich auch nur auf meinem Host eingegrenzt `sudo ufw allow from 10.0.2.2 to any port 22`.


## 6 - Testing


## 7 - Reflexion

## 8 - Quellen
D