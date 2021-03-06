**Inhaltsverzeichnis**
- [Cloud Computing](#cloud-computing)
  - [IaaS](#iaas)
  - [PaaS](#paas)
  - [SaaS](#saas)
- [Git](#git)
- [Vagrant](#vagrant)
  - [Boxen](#boxen)
  - [Konfiguration](#konfiguration)
  - [Provisioning](#provisioning)
  - [Provider](#provider)
  - [Synchronsierte Ordner](#synchronsierte-ordner)
- [Packer](#packer)
- [Docker](#docker)
- [Kubernetes](#kubernetes)

## Cloud Computing
Cloud Computing (Rechnerwolke) versteht man die Ausführung von Programmen, die nicht auf dem lokalen Rechner installiert sind, sondern auf einem anderen Rechner, der aus der Ferne (remote) aufgerufen wird.
Technischer formuliert umschreibt das Cloud Computing den Ansatz, IT-Infrastrukturen (z.B. Rechenkapazität, Datenspeicher, Datensicherheit, Netzkapazitäten oder auch fertige Software) über ein Netz zur Verfügung zu stellen, ohne dass diese auf dem lokalen Rechner installiert sein müssen.
### IaaS
IaaS (Infrastructure as a Service) bezeichnet die Infrastruktur (auch "Cloud Foundation"), die die unterste Schicht des Cloud Computing darstellen solle. Es ist eine vollständige Selbstbedienung für den Zugriff auf die Recheninstanzen (VMs) und die Überwachung von Computern, Netzwerken, Speicher und anderen Diensten. IaaS ermöglicht es Unternehmen, Ressourcen nach Bedarf zu erwerben, anstatt Hardware direkt kaufen zu müssen.<br> 
Beispiele für IaaS Provider sind AWS, GCE (Google Compute Engine), MS Azure, DigitalOcean u.v.m.

<u>Einsatzzwecken</u><br>
Die verschienden Einsatzzwekce



| Vorteile                                                                                     | Nachteile                                                                                          |
| -------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------- |
| Das flexibelste Cloud-Computing-Modell                                                       | Sicherheitsbedrohungen können immer noch vom Host oder anderen virtuellen Maschinen (VMs) ausgehen |
| Einfache, automatisierte Bereitstellung von Speicher, Netzwerken, Servern und Rechenleistung |                                                                                                    |
| Hardware-Käufe können verbrauchsabhängig erfolgen                                            |                                                                                                    |
| Volle Kontrolle über die Infrastruktur                                                       |                                                                                                    |
| Ressourcen können nach Bedarf gekauft werden (Hochgradig skalierbar)                         |                                                                                                    |

### PaaS
Beim PaaS (Plattform as a Service) erstellt der Entwickler die Anwendung und lädt diese in die Cloud. Diese kümmert sich dann selbst um die Aufteilung auf die eigentlichen Verarbeitungseinheiten. Im Unterschied zu IaaS hat der Benutzer hier keinen direkten Zugriff auf die Recheninstanzen. Er betreibt auch keine virtuellen Server.<br>
Beispiele dafür sind AWS Elastic Beanstalk, Windows Azure, Heroku, Force.com, Google App Engine, Apache Stratos, OpenShift.

Einsatzzwecken

| Vorteile                                                                                 | Nachteile                    |
| ---------------------------------------------------------------------------------------- | ---------------------------- |
| Einfache, kostengünstige Entwicklung und Bereitstellung von Apps                         | Datensicherheit              |
| Skalierbar                                                                               | Integrationen                |
| Hochverfügbar                                                                            | Anpassung von Legacysystemen |
| Entwickler können Apps anpassen, ohne sich um die Wartung der Software kümmern zu müssen | Laufzeitprobleme             |
| Signifikante Reduzierung des Codierungsaufwands                                          | Betriebliche Einschränkung   |

### SaaS
SaaS (Software as a Service) Die Anwendungssicht stellt die abstrakteste Sicht auf Cloud-Dienste dar. Hierbei bringt der Benutzer seine Applikation weder in die Cloud ein, noch muss er sich um Skalierbarkeit oder Datenhaltung kümmern. Er nutzt eine bestehende Applikation, die ihm die Cloud nach aussen hin anbietet.
Beispiele dafür sind Google Workspace, Dropbox, Salesforce, Cisco WebEx.

-------
## Git
Einige Cheat-Sheets zu Git gibt es [hier](/Images%20Doku/Git_Cheat_Sheet.png)

-------
## Vagrant
### Boxen
Boxen sind bei Vagrant vorkonfigurierte VMs (Vorlagen). Diese sollen den Prozess der Softwareverteilung und der Entwicklung beschleunigen. Jede Box, die von dem Nutzer benutzt wurde, wird auf dem Computer gespeichert und muss so nicht wieder aus dem Internet geladen werden.

Boxen können explizit durch den Befehl `vagrant box add [box-name]` oder `vagrant box add [box-url]` heruntergeladen und durch `vagrant box remove [box-name]` entfernt werden. Ein **box-name** ist dabei durch Konvention wie folgt aufgebaut: Entwickler/Box (z.B. ubuntu/xenial64). Die Vagrant Boxen-Plattform dient dabei als Austauschstelle für die Suche nach Boxen und das Publizieren von eigenen Boxen.

### Konfiguration
Die gesamte Konfiguration erfolgt im Vagrantfile, das im entsprechenden Verzeichnis liegt. Die Syntax ist dabei an die Programmiersprache Ruby) angelehnt:

```ruby
Vagrant.configure("2") do |config|
    config.vm.define :apache do |web|
        web.vm.box = "bento/ubuntu-16.04"
        web.vm.provision :shell, path: "config_web.sh"
        web.vm.hostname = "srv-web"
        web.vm.network :forwarded_port, guest: 80, host: 4567
        web.vm.network "public_network", bridge: "en0: WLAN (AirPort)"
end
```
Mit dieser Konfiguration wird ein Ubuntu 16.04 Image genommen und Apache vorinstalliert. Zusätzlich wird auf dem Host-Laptop der Port 4567 für den Guest-Webserver weitergeleitet, sodass auf dem Host nun `http://127.0.0.1:4567/` eingegeben werden kann und auf dem Webserver zugegriffen werden.

Das Konzept für das Füllen des Vagrantfiles stelle ich mir wie folgt vor. 
1. Das beschreibende für die VM `vm.define do |var|`
2. Die Konfiguration, die in der VM passieren müssen (Box, hostname, Portforwarding, Static IP, Shell Files, usw.)
3. Die Änderungen, die man in Virtualbox vornehmen müssen (Memory, Anzeigename usw.) 

### Provisioning
Provisioning bedeutet bei Vagrant, Anweisung an ein anderes Programm zu geben. In den meisten Fällen an eine Shell, wie Bash. Die nachfolgenden Zeilen installieren den Web Server Apache.

```ruby
  config.vm.provision :shell, inline: <<-SHELL 
      sudo apt-get update
      sudo apt-get -y install apache2
    SHELL
```
### Provider
Die Angabe des Providers im Vagrantfile definiert, welche Dynamic Infrastructure Platform zum Einsatz kommt (z.B. VirtualBox).
```ruby
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "512"  
  end
```

### Synchronsierte Ordner
Synchronisierte Ordner ermöglichen es der VM auf Verzeichnisse des Host-Systems zuzugreifen, wie Z.B. das HTML-Verzeichnis des Apache-Webservers mit dem Host-Verzeichnis synchronisieren (wo das Vagrantfile liegt):
```ruby
    Vagrant.configure(2) do |config|
        config.vm.synced_folder ".", "/var/www/html"  
    end
```
**Wichtig**: Standardmässig wird das aktuelle Vagrantfile-Verzeichnis in der VM unter /vagrant gemountet. Mit `vagrant reload --provision` kann man die Vagrant-VM mit allfällige Provision-Änderungen neu starten.

--------------
## Packer
Packer ist ein Tool zur **Erstellung von Images** bzw. Boxen für eine Vielzahl von Dynamic Infrastructure Platforms mittels einer Konfigurationsdatei.
Diese Konfigurationsdatei wird im JSON Format geschrieben und die Erstellung eines darauffolgenden Images wird mit `packer build` angelegt.
```json
{
  "provisioners": [
    {
      "type": "shell",
      "execute_command": "echo 'vagrant'|sudo -S sh '{{.Path}}'",
      "override": {
        "virtualbox-iso": {
          "scripts": [
            "scripts/server/base.sh",
          ]
        }
      }
    }
  ],
  "builders": [
    {
      "type": "virtualbox-iso",
  "boot_command": [
    " preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ubuntu-preseed.cfg<wait>",
  ],
    }
  ],
  "post-processors": [
    {
      "type": "vagrant",
      "override": {
        "virtualbox": {
          "output": "ubuntu-server-amd64-virtualbox.box"
        }
      }
    }
  ]      
}
```
**Provisioning**\
Auch bei Packer steht Provisioning für Anweisungen an ein anderes Programm (z.B. eine Shell wie Bash).

**Builder**\
Die Builder erstellen ein Image für eine bestimmte dynamische Infrastruktur-Plattform (wie z.B. VirtualBox).

**Post-processors**\
Um ein neues Artefakt/Instanz zu erstellen, werden Ergebnisse auf Builders oder Post-Prozessor geholt.

## Docker
Hier einige Cheat-Sheet für Docker Kommandos.<br>

![Cheat-Sheet](Bilder%20Doku/Docker_Cheat_Sheet.png)
<br>

![Cheat-Sheet](Bilder%20Doku/Docker_Cheat_Sheet.png)

Ein Cheat-Sheet zur Aufbau der Docker Architektur ![](/Bilder%20Doku/Docker_Architecture.png)

## Kubernetes

Kubernetes ist ein Open-Source Programm. Der Verlauf ist in etwa so. Es gibt ein Master Node, der für das Zentralverwalten für das Kubernetes Cluster und aller Worker Nodes zuständig ist.


![Abbild](/LB2/Bilder/K8s_Architecture.png)

Auf den Worker Nodes laufen zwei Prozesse;
* `kubelet`
  * Liest der Health Status der verschiendener Pods heraus
* `kube-proxy`
  * Leitet allfällige TCP/UDP Ports von und zu den versch. Pods, evtl. vom Internet, der dann via Load Balancer (welcher auf einen von denen Pods als Service lauft) reinkommt.

Ein **Pod** besteht aus den folgenden Komponenten
* Docker container mit einem Image
* Storage 
* Einzigartige IP-Adresse
* Variabeln die bei der Laufzeit am Pod gegeben werden


![](/Bilder%20Doku/K8s_Pods.png)



Ein Pod lauft immer auf einem Node und können bis zu 150'000 Pods am einem Node laufen.

![](Bilder%20Doku/K8s_Nodes.png)

Um einen Container auf einem produktiven Pod zu laufen, müssen 2 Files erstellt werden
* `Deployment`
  * Definiert die Erstellung des Pods mit verschiedenster Metadata (`Name des Pods, dazugehörige Label, Update-Einstellungen, Replica-Sets, Image, Ports` u. v. m)
* `Services`
  * Um das Deployment File überhaupt erfolgreich zu haben, muss der ausgefühter Service, der im Pod lauft, definiert werden. Metadata wären der `Name des Services`,der `Label`, die `verwendeten Ports` und der `Selector-Keyword`.


