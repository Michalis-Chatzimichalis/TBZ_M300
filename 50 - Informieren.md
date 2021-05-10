## Cloud Computing
Cloud Computing (Rechnerwolke) versteht man die Ausführung von Programmen, die nicht auf dem lokalen Rechner installiert sind, sondern auf einem anderen Rechner, der aus der Ferne (remote) aufgerufen wird.
Technischer formuliert umschreibt das Cloud Computing den Ansatz, IT-Infrastrukturen (z.B. Rechenkapazität, Datenspeicher, Datensicherheit, Netzkapazitäten oder auch fertige Software) über ein Netz zur Verfügung zu stellen, ohne dass diese auf dem lokalen Rechner installiert sein müssen.
### IaaS
IaaS (Infrastructure as a Service) bezeichnet die Infrastruktur (auch "Cloud Foundation"), die die unterste Schicht des Cloud Computing darstellen solle. Es ist eine vollständige Selbstbedienung für den Zugriff auf die Recheninstanzen (VMs) und die Überwachung von Computern, Netzwerken, Speicher und anderen Diensten. IaaS ermöglicht es Unternehmen, Ressourcen nach Bedarf zu erwerben, anstatt Hardware direkt kaufen zu müssen. Beispiele für IaaS Provider sind AWS, GCE (Google Compute Engine), MS Azure, DigitalOcean u. v. m.
Einsatzzwecken

| Vorteile | Nachteile |
| -------- | --------- |
| Das flexibelste Cloud-Computing-Modell | Sicherheitsbedrohungen können immer noch vom Host oder anderen virtuellen Maschinen (VMs) ausgehen
| Einfache, automatisierte Bereitstellung von Speicher, Netzwerken, Servern und Rechenleistung | Text	
| Hardware-Käufe können verbrauchsabhängig erfolgen	| Text
| Volle Kontrolle über die Infrastruktur | Text
| Ressourcen können nach Bedarf gekauft werden (Hochgradig skalierbar) | Text |

### PaaS
PaaS (Plattform as a Service) Der Entwickler erstellt die Anwendung und lädt diese in die Cloud. Diese kümmert sich dann selbst um die Aufteilung auf die eigentlichen Verarbeitungseinheiten. Im Unterschied zu IaaS hat der Benutzer hier keinen direkten Zugriff auf die Recheninstanzen. Er betreibt auch keine virtuellen Server.
Beispiele dafür sind AWS Elastic Beanstalk, Windows Azure, Heroku, Force.com, Google App Engine, Apache Stratos, OpenShift

Einsatzzwecken

| Vorteile | Nachteile |
| -------- | --------- |
| Einfache, kostengünstige Entwicklung und Bereitstellung von Apps | Datensicherheit |
| Skalierbar | Integrationen	
| Hochverfügbar	| Anpassung von Legacysystemen
| Entwickler können Apps anpassen, ohne sich um die Wartung der Software kümmern zu müssen | Laufzeitprobleme
| Signifikante Reduzierung des Codierungsaufwands | Betriebliche Einschränkung |

### SaaS
SaaS (Software as a Service) Die Anwendungssicht stellt die abstrakteste Sicht auf Cloud-Dienste dar. Hierbei bringt der Benutzer seine Applikation weder in die Cloud ein, noch muss er sich um Skalierbarkeit oder Datenhaltung kümmern. Er nutzt eine bestehende Applikation, die ihm die Cloud nach aussen hin anbietet.
Beispiele dafür sind Google Workspace, Dropbox, Salesforce, Cisco WebEx

| Vorteile | Nachteile |
| -------- | --------- |
| Text | Text |
| Text | Text |	
| Text | Text |
| Text | Text |
| Text | Text |



## Packer - Beschreibung
Packer ist ein Tool zur Erstellung von Images bzw. Boxen für eine Vielzahl von Dynamic Infrastructure Platforms mittels einer Konfigurationsdatei.
Um a Images zu erstellen, benutzt man packer build und die Konfigurationsdatei wird im JSON Format 

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

**Provisioning**
Auch bei Packer steht Provisioning für Anweisungen an ein anderes Programm (z.B. eine Shell wie Bash).

**Builder**
Die Builder erstellen ein Image für eine bestimmte dynamische Infrastruktur-Plattform (wie z.B. VirtualBox).

Post-processors
Sind Bestandteile von Packer, die das Ergebnis eines Builders oder eines anderen Post-Prozessor übernehmen, um damit ein neues Artefakt zu erstellen.

