In der LB2 werde ich mittels Docker einen Image einer einfachen Webapplikation erstellen und der dann über Container Orchestrierung (Kubernetes) automatisch bereitstellen. Andere Dienste, wie ein Anaylse Tool oder ein Reverse Proxy sind auch in Bearbeitung/Pilotphase.<br>
Mit diesem Befehl 
```shell
docker run --name web_app -p 8080:8080 michalis07/webapp
```

**Inhaltsverzeichnis**
- [- Quellen](#--quellen)
- [Technische Übersicht](#technische-übersicht)
- [Voraussetzungen](#voraussetzungen)
- [Funktionen](#funktionen)
- [Deklarativer Aufbau](#deklarativer-aufbau)
  - [Vorbereitung](#vorbereitung)
  - [Docker Hub Konto anbinden](#docker-hub-konto-anbinden)
  - [Dockerfile](#dockerfile)
  - [Docker Container starten](#docker-container-starten)
- [Kubernetes Orchestrierung](#kubernetes-orchestrierung)
  - [Initialisierung und Erste Schritte](#initialisierung-und-erste-schritte)
  - [Nodes und Pods definieren](#nodes-und-pods-definieren)
- [Sicherheit](#sicherheit)
- [Testing](#testing)
- [Reflexion](#reflexion)
- [Quellen](#quellen)
--------

## Technische Übersicht
![Bild von der Aufstellung]()


## Voraussetzungen
Die Voraussetzungen fürs folgende Projekt sind folgende:

- GitHub
- Git/Bash
- Virtualbox (in diesem Fall MAAS der TBZ Cloud)
- Docker
  -  Kenntnisse von Vorteil
  -  Docker Hub Account
- Browser

## Funktionen
- Die node.js Applikation wird im Docker Image namens **webapp** packetiert und als Container gestartet. Sie stellt eine einfache HTML-Seite auf Port 8080 dar. 

## Deklarativer Aufbau
### Vorbereitung
Zuerst gehe ich auf WireGuard, um das VPN der TBZ-Cloud zu aktivieren. Danach gebe ich folgendes Befehl im Git/Bash ein.
```shell
ssh ubuntu@10.1.43.13
```
 Das Passwort finde ich heraus, wenn ich auf der HTTP-Seite des Servers gehe und unter **Accessing** die `data/.ssh/passwd-Datei` öffne, bekomme ich das Passwort.

Zuerst führe ich das um den Server zu aktualisieren
```shell
apt-get update && apt-get upgrade -y
```

### Docker Hub Konto anbinden
Mit diesem Befehl lege ich meinen Docker Hub Konto an und wird für mein Passwort gefordert.
```shell
docker login --username=michalis07
```
Bei erfolgreichem Anlegen kann ich ohne Hindernis Images auf Docker Hub hochzuladen ('pushen'). Der erfolgreicher Zugriff wird da dargestellt.<br> 
![Erfolgreicher Zugriff](/LB2/Bilder/Docker_Account_Erfolg.png)

Der Inhalt der Website ändere ich, indem ich 'nano /views/home.pug' eingebe und das HTML-Content anpassen.
![Content Änderung](/LB2/Bilder/Content_Änderung.png)

### Dockerfile
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

### Docker Container starten
Das Docker Container starte ich mit und bekomme die SHA256 ID des Containers.
```shell
docker container run -d --name michalis-web -p 8080:8080 michalis07/webapp
```
![](/LB2/Bilder/Docker_Web_App_Run.png)

Mit diesen beiden Varianten kann man den laufenden Container als Prozess ansehen. Der Zugriff auf die HTML-Seite erfolgt mit der URL `10.1.43.13:8080`.
```shell
docker ps | grep -i michalis-web
docker container ls | grep -i michalis-web
```

## Kubernetes Orchestrierung
### Initialisierung und Erste Schritte
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

Der .kube Ordner soll wie folgt aussehen.

```shell
apoll@I-320s-MIC MINGW64 ~/.kube
$ ls -l
total 46748
drwxr-xr-x 1 apoll 197609        0 Jun 21 15:49 cache/
-rw-r--r-- 1 apoll 197609     5585 Jun 21 15:48 config
-rwxr-xr-x 1 apoll 197609 47859200 Jun 21 15:45 kubectl.exe*
```
Um zu schauen, ob kubectl erfolgreich installiert und mit der Config-Datei auf das Dashboard zu kommen, gebt man diesen Befehl ein.
```shell
$ kubectl cluster-info

Kubernetes control plane is running at https://10.1.43.13:6443
KubeDNS is running at https://10.1.43.13:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
```
Die aktuell laufenden Pods (Hosts) sind mit diesem Befehl ersichtlich.
```shell
$ kubectl get pods -o wide

NAME                             READY   STATUS    RESTARTS   AGE
eclipse-theia-79dcdc756d-4ckbp   1/1     Running   1          58d
```

Mit diesem Befehl sehe ich alle Services die auf diesem Kubernetes-Cluster momentan laufen.

```shell
$ kubectl get svc

NAME            TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
eclipse-theia   LoadBalancer   10.107.23.108   <pending>     3000:32400/TCP   58d
kubernetes      ClusterIP      10.96.0.1       <none>        443/TCP          58d
```
Nun kommt man auf das Dashboard wie folgt; man gebt diesen Befehl im Bash ein und der leitet der 10.43.1.13:6443 aufs localhost:8001.

```shell
kubectl --kubeconfig config proxy
```
Auf das Dashboard greift man über diesen [URL](http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/) an. Danach muss man Token auswählen und den Token, der auf der Homepage des TBZ-VMs (10.43.1.13 unter dem Punkt Cluster-Info > Token) zu finden ist, eingeben.<br>
![](Bilder/K8s_Dashboard_login.png)

Das Dashboard sieht dann wie folgt aus. ![](/LB2/Bilder/K8s_Dashboard.png)

### Nodes und Pods definieren
Als Vorbereitung werde ich die Repository von Marcello auf der VM klonen. Dafür erstelle ich den Ordner `TEMP_K8s` und führe den untenstehenden Befehl aus.

```shell
$ sudo git clone https://gitlab.com/ser-cal/cal_kubernetes.git

$ cd cal_kubernetes | ls -l

total 24
drwxr-xr-x 2 root root 4096 Jun 28 12:39 Deployments
drwxr-xr-x 2 root root 4096 Jun 28 12:39 Pods
-rw-r--r-- 1 root root 4816 Jun 28 12:39 README.md
drwxr-xr-x 2 root root 4096 Jun 28 12:39 Services
drwxr-xr-x 2 root root 4096 Jun 28 12:39 images
```
Um das erste Pod im Verzeichnes `Pods` zu starten, muss das Pod-Manifest deployed werden. Dieses Pod-Manifest sieht wie folgt aus und definiert der Container mit meinem Image, den ich auf Docker Hub zugleich publiziert und auch lokal habe.

```yml
## M. Chatzimichalis: getestet am 28.6.2021
## Beispiel Pod YAML:

apiVersion: v1
kind: Pod
metadata:
  name: michalis-pod
  labels:
    app: web

spec:
  containers:
  - name: michalis-container
    image: michalis07/webapp:1.0
    ports:
    - containerPort: 8080
```
Um den Pod nun zu deployen gebe ich diesen Befehl ein. Mit dem Befehl `kubectl get pods -o wide` zeige ich alle Dienste.

```shell
$ sudo mv calisto-pod.yaml michalis-pod.yaml
$ kubectl apply -f michalis-pod.yaml
  
  pod/michalis-pod created

$ kubectl get pods -o wide

NAME        READY  STATUS    RESTARTS  AGE   IP         NODE             
michalis-pod 1/1   Running  0         97s   10.244.0.20 m300-13-st18a-cal
```
Nun werde ich über das Deployment mehrere Container in einem Pod laufen. Demnach muss ich den Service, welcher im Pod definiert wird mit einem zusätzlichen File angeben


 

## Sicherheit
## Testing
## Reflexion
## Quellen
Die Beispielsaufgabe mit dem Node.js Applikation besteht von der GitLab Repository vom Marcello Calisto. [Link zur Repository](https://gitlab.com/ser-cal/Container-CAL-webapp_v1/-/tree/master/)
