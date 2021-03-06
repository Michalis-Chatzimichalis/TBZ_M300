# M300_Services

![Git](/Bilder%20Doku/Cover_Readme.png)
\
Quelle: [Medium-Artikel](https://medium.com/analytics-vidhya/git-101-cdf8d18b895e)
## Einleitung allgemein

Dieses Projekt ist der Einstieg ins Informatik-Modul 300 - Plattformübergreifende Dienste in ein Netzwerk integrieren.

Die Aufgaben (KAP10-50) werden fortlaufend unter Projects mitsamt einem Kanban Board geführt.
## Inhaltsverzeichnis

[10 - Toolumgebung](#10---toolumgebung)\
[20 - Infrastruktur](#20---infrastruktur)\
[25 - Sicherheit 1](#25---sicherheit-1)\
[XX - LB1](#xx---lb1)\
[30 - Container](#30---container)\
[35 - Sicherheit 2](#35---sicherheit-2)\
[XX - LB2](#xx---lb2)\
[40 - Container-Orchestrierung](#40---container-orchestrierung)\
[50 - Add-Ons](#50---add-ons)\
[60 - Reflexion](#60---reflexion)

--------

## 10 - Toolumgebung

### GitHub
1. Repo erstellt mit einem readme-File
2. Project mit Kanban Board erstellt
3. Lokale SSH-Key im GitHub Konto hinzugefügt.\
\
![GitHub Kanban Board](/Bilder%20Doku/GitHub2.png)
  
### Git Client und Git Kommando
1. Das Git/Bash exe herunterladen und die standardmässige Installation durchführen (Bei der Auswahl zwischen der Default Branch Name habe ich main gewählt). Nach der erfolgreicher Installation öffne ich Git/Bash in meinem Homeverzeichnis und definiere mein Namen und E-Mail-Adresse, wo für das Identifizieren meiner Commits/Pushes/Pull Requests zuständig ist
2. Bestehende M300 Repo lokal herunterladen
3. Im Masterbranch gewechselt und aktuellste Änderungen mit `git pull` geholt. Danach der Status mit `git status` abgefragt
4. Ordner erstellen für das Initialisieren eines Remote-Repositories
5. Repo herunterladen und clonen. Auf der Startseite meines Repos klicke ich auf Code und kopiere den SSH Link
6. Nachdem gehe ich im Bash Terminal und gebe dies ein. Nun erlaube ich die Verwendung von dieser Quelle und speichere zugleich der SSH-Fingerprint von der Seite github.com.
7. Ich erstelle in Github ein kurzes Textdokument, sodass ich beim Aktualisieren mit `git pull` mein Terminal die neuesten Dateien in der Repo holen kann.
8. Mit `git status` zeige ich mir nachdem pullen den Status an.
9. Nun erstelle ich eine Textdatei und stage sie mit `git add .` , welche alle neuen Dateien für einen Commit und einen anschliessendem Push vorbereiten tut
10. Beim Commit habe ich die Fehlermeldung bekommen das Commit kann nicht stattfinden, da sonst meine E-Mail Adresse veröffentlicht wird.
11. Diese Einstellung deaktivere ich im Github Einstellungen.
12. Nun versuche ich nochmals meine Änderungen in der Remote-Repo zu pushen
13. Die neue Datei ist nach einem Refresh im Browser ersichtlich.\
\
![Remote-Repository ersichtlich](/Bilder%20Doku/Git13.png)
 
### VirtualBox – VM erstellen und einrichten
1. Nun erstelle ich auf mein Windows Rechner eine Ubuntu VM mit einem 20.04 .iso Image
2. Minimal Installation > Hostname eingeben
3. Apache über den Packetmanager installieren.\
\
![Apache über Packetmanager](/Bilder%20Doku/Virtual3.png)
   
### Vagrant – VM erstellen
1. Vagrant von der offiziellen Seite herunterladen und Bash öffnen. Nun erstelle ich im Modulordner ein Ordner namens **MeinVagrantVM** und wechsle in dem.
2. Mit `vagrant init [OS]/[OS_Codename]` und mit `vagrant up --provider virtualbox` , um Virtualbox als Hoster für die VM zu nutzen
3. Mit `vagrant ssh` gelange ich via ssh auf die Vagrant VM. Voraussetzung dafür ist, dass man im demselben Verzeichnis als die VM sein muss.
4. Die VM schalte ich dann über Virtualbox aus.\
\
![Vagrant VM](/Bilder%20Doku/Vagrant3.png)
 
### Apache automatisiert
1. Im **M300 Verzeichnis** wechseln
2. Mit `vagrant up` kann die vordefinierte VM mit dem Apache Webserver gestartet werden. Die virtuelle Maschine konfiguriere ich im Virtualbox mit einem NAT Network Adapter sowie die bestehende Ubuntu Maschine, die ich in der vorherigen Aufgabe erstellt habe. 
3. Nun verbinde ich mich nach dem Starten mit `vagrant ssh` mit der VM und lese die IP-Adresse aus. Nach einem erfolgreichen `ping` zwischen den beiden NAT Network Maschinen öffne ich Firefox auf der Ubuntu und gehe zur IP-Adresse des Apache VM’s.\
\
![Apache Zugriff](/Bilder%20Doku/Apache2.png)
 
### VS Code Extensions
Nun lade ich drei Extensions im VS-Code herunter;
* Markdown All in One (von Yu Zhang)
* Vagrant Extension (von Marco Stanzi)
* vscode-pdf Extension (von tomiko1207)

Für Markdown ist folgendes [Cheat Sheet](https://github.com/adam-p/markdown-here/wiki/Markdown-Here-Cheatsheet) nützlich.
 
1. Damit keine Dateien der virtuellen Maschinen dem Cloud-Repository hinzugefügt werden (da Dateien zu gross), müssen diese in den Einstellungen "exkludiert" werden.
2. Repo öffnen > Datei erstellen > Git gehen > Rechtsklick auf Eintrag unter Changes > Stage Changes
3. Im MessageBox kann ein Commit-Message eingegeben werden. Commit wird unter die Kategorie Commit angezeigt.
4. Auf einem Klick auf Haken neben dem Commit kann man das nun in der Repo pushen. Beim Pop-Up auf Push klicken.
5. Nun ist der File in der Remote Repo ersichtlich.\
\
![Commit & Push im VS-Code](/Bilder%20Doku/VS_Code2.png)
 
## 20 - Infrastruktur
Sie können eine Dynamischen Infrastruktur-Plattform (Private Cloud) einrichten, auf der Virtuelle Maschinen auf Basis von konsistenten und wiederholten Definitionen automatisiert erstellt werden können.

### Beispielsaufgaben
Für den ersten Beispiel werde ich eine DB mit einem phpmyadmin GUI via Vagrantfile einrichten. Die benötigten Dateien findet man [hier](20%20-%20Beispielsaufgabe%20DB/).

Info-Datei für [Vagrant und Packer](/50%20-%20Informieren.md)

## 25 - Sicherheit 1
Die UFW (Uncomplicated Firewall) ist eine integrierte Kommandozeile-Tool. Das Ziel von UFW ist es, ein unkompliziertes Kommandozeilen-basiertes Frontend für das sehr leistungsfähige, aber nicht gerade einfach zu konfigurierende iptables zu bieten. UFW unterstützt sowohl IPv4 als auch IPv6. Die UFW habe ich in dieser [Teil](/LB1/README.md#5---sicherheit) meiner LB1 verwendet.<br>
Der Reverse Proxy ist ein Proxy, der Ressourcen für einen Client von einem oder mehreren Servern holt. Die Adressumsetzung wird in der entgegengesetzten Richtung vorgenommen, wodurch die wahre Adresse des Zielsystems dem Client verborgen bleibt. Während ein typischer Proxy dafür verwendet werden kann, mehreren Clients eines internen (privaten – in sich geschlossenen) Netzes den Zugriff auf ein externes Netz zu gewähren, funktioniert ein Reverse Proxy genau andersherum.

## XX - LB1
In Verlauf vom diesem Modul müssten wir für die LB1 einige Dienste automatisiert zur Verfügung stellen. Dies habe ich mit Docker Container erledigt, um Plex, Sonarr, Radarr und Portainer hochzufahren. Die detaillierte Beschreibung und Aufbau meiner LB1 finden Sie [hier](/LB1).

## 30 - Container
Entwickler können Software lokal bauen, die woanders genauso laufen wird – sei es ein Rack in der IT-Abteilung, der Laptop eines Anwenders oder ein Cluster in der Cloud.

Administratoren können sich auf die Netzwerke, Ressourcen und die Uptime konzentrieren und müssen weniger Zeit mit dem Konfigurieren von Umgebungen und dem Kampf mit Systemabhängigkeiten verbringen.
* Container teilen sich Ressourcen mit dem Host-Betriebssystem
* Container können im Bruchteil einer Sekunde gestartet und gestoppt werden
* Container sind leichtgewichtig, d.h. es können dutzende parallel betrieben werden.
### Microservices
Einer der grössten Anwendungsfälle und die stärkste treibende Kraft hinter dem Aufstieg von Containern sind Microservices.

Microservices sind ein Weg, Softwaresysteme so zu entwickeln und zu kombinieren, dass sie aus kleinen, unabhängigen Komponenten bestehen, die untereinander über das Netz interagieren. Das steht im Gegensatz zum klassischen, monolithischen Weg der Softwareentwicklung, bei dem es ein einzelnes, grosses Programm gibt.

Wenn solch ein Monolith dann skaliert werden muss, kann man sich meist nur dazu entscheiden, vertikal zu skalieren (scale up), zusätzliche Anforderungen werden in Form von mehr RAM und mehr Rechenleistung bereitgestellt. Microservices sind dagegen so entworfen, dass sie horizontal skaliert werden können (scale out), indem zusätzliche Anforderungen durch mehrere Rechner verarbeitet werden, auf die die Last verteilt werden kann.

In einer Microservices-Architektur ist es möglich, nur die Ressourcen zu skalieren, die für einen bestimmten Service benötigt werden, und sich damit auf die Flaschenhälse des Systems zu beschränken. In einem Monolith wird alles oder gar nichts skaliert, was zu verschwendeten Ressourcen führt.

### Docker
Die Standard-Registry ist der Docker Hub, auf dem tausende öffentlich verfügbarer Images zur Verfügung stehen, aber auch "offizielle" Images.

Viele Organisationen und Firmen nutzen eigene Registries, um kommerzielle oder "private" Images zu hosten, aber auch um den Overhead zu vermeiden, der mit dem Herunterladen von Images über das Internet einhergeht.

## 35 - Sicherheit 2


## XX - LB2
Die LB2, bei der ich einen Docker Image von einer Webapplikation erstelle und den Container starte, wird in diesem [Ordner](/LB2) beschrieben.

## 40 - Container-Orchestrierung

## 50 - Add-Ons
In dieser [Datei](/50%20-%20Informieren.md) werden alle wichtige Begriffe (wie IaC, Cloud Computing, IaaS), Tools (Vagrant, Packer, AWS Cloud usw.) und Techniken (wie CI/CD, TDD) usw. detailliert erklärt.

## 60 - Reflexion
