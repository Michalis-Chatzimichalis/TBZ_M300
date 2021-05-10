# M300_Services

# Einleitung allgemein
Dieses Projekt ist der Einstieg ins Informatik-Modul 300 - Plattformübergreifende Dienste in ein Netzwerk integrieren.

Die Aufgaben (KAP10-50) werden fortlaufend unter Projects mitsamt einem Kanban Board geführt.

# Inhaltsverzeichnis

* 10-Toolumgebung
* 20-Infrastruktur
* 25-Sicherheit 1
* 30-Container
* 35-Sicherheit 2
* 40-Container-Orchestrierung
* 50-Add-Ons
* 60-Reflexion

## 10 - Toolumgebung

### GitHub
Repo erstellt mit einem readme-File

Project mit Kanban Board erstellt
  
Lokale SSH-Key im GitHub Konto hinzugefügt
  
### Git Client und Git Kommando
Git/Bash exe heruntergeladen und Variabeln definiert
 
Bestehende M300 Repo lokal herunterladen
 
Im Masterbranch gewechselt und aktuellste Änderungen mit git pull geholt. Danach der Status mit git status abgefragt
  
Ordner erstellen für das Initialisieren eines Remote-Repositories
 

Repo herunterladen und clonen
Auf der Startseite meines Repos klicke ich auf Code und kopiere den SSH Link
 
Nachdem gehe ich im Bash Terminal und gebe dies ein. Nun erlaube ich die Verwendung von dieser Quelle und speichere zugleich der SSH-Fingerprint von der Seite github.com.
 
Ich erstelle in Github ein kurzes Textdokument, sodass ich beim Aktualisieren mit git pull mein Terminal die neuesten Dateien in der Repo holen kann. 
 
 
Mit git status zeige ich mir nachdem pullen den Status an.
 
Nun erstelle ich eine Textdatei und stage sie mit git add -A ., welche alle neuen Dateien für einen Commit und einen anschliessendem Push vorbereiten tut.
 
Beim Commit habe ich die Fehlermeldung bekommen das Commit kann nicht stattfinden, da sonst meine E-Mail Adresse veröffentlicht wird
 
Diese Einstellung deaktivere ich im Github Einstellungen
 
Nun versuche ich nochmals meine Änderungen in der Remote-Repo zu pushen
 
Die neue Datei ist nach einem Refresh im Browser ersichtlich
 
### VirtualBox – VM erstellen und einrichten
Nun erstelle ich auf mein Windows Rechner eine Ubuntu VM mit einem 20.04 .iso Image
 
Minimal Installation > Hostname
 
Apache über PacketManager installieren.
   
### Vagrant – VM erstellen
Vagrant von der offiziellen Seite herunterladen und Bash öffnen. Nun erstelle ich im Modulordner ein Ordner namens MeinVagrantVM und wechsle in dem.
 
Mit vagrant init [OS]/[OS_Codename] und mit vagrant up --provider virtualbox, um Virtualbox als Hoster für die VM zu nutzen
 
Mit vagrant ssh gelange ich via ssh auf die Vagrant VM. Voraussetzung dafür ist, dass man im demselben Verzeichnis als die VM sein muss.
 
Die VM schalte ich dann über Virtualbox aus.
 
### Apache automatisiert
Im M300 Verzeichnis wechseln
 
Mit vagrant up kann die vordefinierte VM mit dem Apache Webserver gestartet werden. Die virtuelle Maschine konfiguriere ich im Virtualbox mit einem NAT Network Adapter sowie die bestehende Ubuntu Maschine, die ich in der vorherigen Aufgabe erstellt habe. 
Nun verbinde ich mich nach dem Starten mit vagrant ssh mit der VM und lese die IP-Adresse aus. Nach einem erfolgreichen ping zwischen den beiden NAT Network Maschinen öffne ich Firefox auf der Ubuntu und gehe zur IP-Adresse des Apache VM’s.
 
### VS Code Extensions
Nun lade ich drei Extensions im VS-Code herunter;
•	Markdown All in One (von Yu Zhang)
•	Vagrant Extension (von Marco Stanzi)
•	vscode-pdf Extension (von tomiko1207)

Für Markdown ist folgendes Cheat Sheet nützlich Cheat-Sheet
 
Damit keine Dateien der virtuellen Maschinen dem Cloud-Repository hinzugefügt werden (da Dateien zu gross), müssen diese in den Einstellungen "exkludiert" werden.
 
Repo öffnen > Datei erstellen > Git gehen > Rechtsklick auf Eintrag unter Changes > Stage Changes
 
Im MessageBox kann ein Commit-Message eingegeben werden. Commit wird unter die Kategorie Commit angezeigt
 
Auf einem Klick auf Haken neben dem Commit kann man das nun in der Repo pushen. Beim Pop-Up auf Push klicken.
 
Nun ist der File in der Remote Repo ersichtlich
 


## 20 - Infrastruktur

## 25 - Sicherheit 1

## 30 - Container

## 35 - Sicherheit 2

## 40 - Container-Orchestrierung

## 50 - Add-Ons

## 60 - Reflexion