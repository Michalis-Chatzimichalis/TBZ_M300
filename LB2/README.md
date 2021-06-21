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
## 4.5 - Kubernetes Orchestrierung
Auf meinen lokalen Client (Host) installiere ich KubeCTL. Im Verzeichnis C:\Users\apoll\ lade ich 
```shell
curl -LO https://dl.k8s.io/v1.21.0/bin/windows/amd64/kubectl.exe.sha256
```
Danach gebe ich `kubectl.exe` im cmd rein und kubectl wird installiert.
Mit `kubectl version` kann die Version überprüft werden.

Nun erstelle ich den Verzeichnis **.kube** und wechsle zu dem, um die Konfigurationsdatei für das Kubernetes Cluster abzulegen, erstelle ich die leere Datei **config**.
Diesen Inhalt kopiere ich rein und speichere es ab.
```kube
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUM1ekNDQWMrZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRJeE1EUXpNREUyTWpneE5Wb1hEVE14TURReU9ERTJNamd4TlZvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBTWJVCk9ZSGlNQ0VhRXJadnFGLzN2eUJvOE9QZnRWRWQ0SlRxaER4cE0raDNYWVFWUzFzM0tCcHFjby9TcmxBM29PYW8KTTRJM2xZL2k3N1hBUWw4d1k3RUx2T3JoTEk2WGNxZENObUlJWmY3YmcyNGNMRy9GdXdTT0t0N3hxZ2EyaitxVApxUmNvWHhSTGxZTVlRRFhJK1dTbGVVYkFWMElOTFRROElSa04welJhbUx1ZWppSWlJVmZKdkZFU0NMU1FyM2hZCkNBQlNLT2RlQjFjVVhRdkYwYlZIcDJPS2tEUjRVWXY0ZWVnZUdqVmdaOThZVm9yUTl2WklrZ3J2WlN6UWFQclkKNXJ5b0NWa09ReTV0QmViaXJuNkxjNDBWYzQ3U1R6MFhYa0FqcEd2RFA3YWdNY0lvNjkwTmpQRks1VXJ3YkNHbwpOUVk2V1RIVW5ueThNaWJJR2VNQ0F3RUFBYU5DTUVBd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0hRWURWUjBPQkJZRUZMbnNsUWgvR0ZqbmpScEMrRDBqUXhYSjNCK3RNQTBHQ1NxR1NJYjMKRFFFQkN3VUFBNElCQVFBUkQ2NnBObFk2UlNBQXkzdjIvQ3dualhlYk1XQWZTYVQ5NStrMVRld3RLV2pRQk1iYwpubFBaSFZlQ2hUdXJPMW9YdE5rUm9RdEdTRnMxWlRPUU9jMjhnVzQwc3JUOU5MWWg0NVNBcjEzcVZTR1NjZU1ECjh6V2NXaHhMbjdzSWxuVU5YVTQ0WWZjVWlscUViWWlLK3F5R01LRTJiSmF6K0c0bC9ZM2x6MkRYZWlmY2lBMXcKMVZCVmFheFBCMVBETld2amhUNXZLNXlWWEhNT3ByUVY5NUJ0UEJ1SnlCbEZDSXpHaVdNdFJyNUt2YXlPYlZFbQpsbG52ZjI4VHcyTFVhWGVFODRtVzlUVng3VkFaelVoUmY2dG5TSFlHOSsxRXQ0QkZQOEFsZndaWDdIVzluc1VkCmVjTHVWS3B6THVTVElqNjhaVGl2YzVhSHhtZGg0VWhNNFdsNwotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://10.1.43.13:6443
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
    client-certificate-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURFekNDQWZ1Z0F3SUJBZ0lJY1Q2ZksrcGttVEl3RFFZSktvWklodmNOQVFFTEJRQXdGVEVUTUJFR0ExVUUKQXhNS2EzVmlaWEp1WlhSbGN6QWVGdzB5TVRBME16QXhOakk0TVRWYUZ3MHlNakEwTXpBeE5qSTRNVGRhTURReApGekFWQmdOVkJBb1REbk41YzNSbGJUcHRZWE4wWlhKek1Sa3dGd1lEVlFRREV4QnJkV0psY201bGRHVnpMV0ZrCmJXbHVNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQXdCWTQyS1ROZGV1Um5uMEIKdFczRTY1RHd0UmphTXFXemhJZWpYdkFNNVhtV2Y2TzRtdlM3VVZKUmVwNmMrWEdwSWVsU1hhRFVESjJIWVdYWgpOUW1ERVhJdU1pcG53Rlhab1VKb1cwN3ZYRlRyZm1oT2xCdzF1OVZPTU1Vb2lMeUc0cHpsV1g0OFI0M3d3R0FpCjhURERNZnBra2lyR3dRQVlmRlBsc2dKNVdHK2p3OVpGZUtjaUppMlJoM0g1UXhxVlg3MUlNRDJ5cHE5a3ZsQk4KeXdCTW5YM3hETHJwZ1BZYjdvSHMySmhCMjF3RWRucllndTR2cVgyYUc0LzJhL3JxSi9RWXBFeE82KzgzU2NiUgowY21HT2ZzdjVNSXU0NkZQakJ2akZ5S3VKdUE1THgwUVhvZXQvNnFuZDQyVUVONk5pOEZxaDV1MVkrRWhub1BSCm5Qa2VId0lEQVFBQm8wZ3dSakFPQmdOVkhROEJBZjhFQkFNQ0JhQXdFd1lEVlIwbEJBd3dDZ1lJS3dZQkJRVUgKQXdJd0h3WURWUjBqQkJnd0ZvQVV1ZXlWQ0g4WVdPZU5Ha0w0UFNOREZjbmNINjB3RFFZSktvWklodmNOQVFFTApCUUFEZ2dFQkFEenlPY0JRUEZPSy9nb0EwSldydmkwN1FTS1Z3ejBUZlllOXdXTXd1V0c3QkcvQ2RnWm54R0s0CmNnNDdSV2o4ZUpqY0trckhZamlETEQ3dktBZGsrRktSNDBkQ2lYTys1V3h3eWJtZWwzclVNeUlSbHJSWFF0S0MKNEJjT2JlbXdwQzRNdXpJM0xMVXkxaEZpVzV1SU5hMEdZRUx3eTdOOEM5MWFnN3pSb1BoSExyU0tNOVZFcDNhOQpEVmRUY3M0eWJsTys1RnVpUkpjOWhDWllYUFhTU2U3WktmaVNnN2oyNVNWL0l6ekpDTk5JYlRhRlZBWVNpMDRQClN5VHBSeEI0cXJ6d3M4ZElqUXQzYmUvTzVpMFpVY3FUSDhnV1JTdVgyTWl1L2dqMXFoOHgvcTNvajNOMnY5OWMKWFo1c1ZaT005TnJvek1BUVM0YXhJZldJTU1OdkwxVT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
    client-key-data: LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlFcEFJQkFBS0NBUUVBd0JZNDJLVE5kZXVSbm4wQnRXM0U2NUR3dFJqYU1xV3poSWVqWHZBTTVYbVdmNk80Cm12UzdVVkpSZXA2YytYR3BJZWxTWGFEVURKMkhZV1haTlFtREVYSXVNaXBud0ZYWm9VSm9XMDd2WEZUcmZtaE8KbEJ3MXU5Vk9NTVVvaUx5RzRwemxXWDQ4UjQzd3dHQWk4VERETWZwa2tpckd3UUFZZkZQbHNnSjVXRytqdzlaRgplS2NpSmkyUmgzSDVReHFWWDcxSU1EMnlwcTlrdmxCTnl3Qk1uWDN4RExycGdQWWI3b0hzMkpoQjIxd0VkbnJZCmd1NHZxWDJhRzQvMmEvcnFKL1FZcEV4TzYrODNTY2JSMGNtR09mc3Y1TUl1NDZGUGpCdmpGeUt1SnVBNUx4MFEKWG9ldC82cW5kNDJVRU42Tmk4RnFoNXUxWStFaG5vUFJuUGtlSHdJREFRQUJBb0lCQVFDSU5mbmZucFhYdmRGSQpLdXJ3UmNPeks5ZVZBK2VPckxQdEVlWUdwNER0cE5mVThUc3lIc05KK202dTNoVUFTZG9lb3Y1MlNGcTJDMnI1CjVTZ3VsTzB0ak9NM1RaeSs1ZUhxbVZXNUVmTm9iUXVGV3VBRjVTOHhZQ1FQTDIvNzdueFQ2K0F6SXZJSjU1eEcKUHFYb2xLU0dKMEh6NklPQ1R0Z09LY3dpKytBaWxlVnV4TnZuY0Z4dEN5WWo4OXJtQ2Q5cjdCSHVxY1FhVTcwTgpYOExaeUIxR0RKeSt4aGtlOU52N3UzVnZZbm5mSHJWZzl3SjNlajhOQnU0TGpPYXVIWGFpcWNRWmFOU1N3Z2hlCnc4bTVHOVl4VlFjZUNTSGloUE85T1RLY3JYUGNPWWtCVWhIb2hVelBTcHhudmJ0Qit2QkhXNzdxUU1YSWxyZ0MKVnRWSW0rZHhBb0dCQU51bThKMms4MHRuSFg1QXN1eTZoeSs0NTg4NDJJeTRmeDdmUE5ta2gvZ2pZMElLdmpqZwphaTlPS0pIdjd4QXlvS2YzV3lWVFZBbzNuazdMSWpLRGZyMjlhV2kwN3djcXQ0Y0E3cWtvclJHd3Z5a1o1dFlqCmdlVjN6ejRhQnZTZEo0MEcyaktyNS9yaCs0Q2E4MGkrdkMrK2dub3QzUWRWMXRPL3FUZ3BwazJIQW9HQkFOL2YKaW4yTzJ0aUhaVDRMVzcyK3RFd1pPazFpVHFRejlnZFh5cnZZemdtZ0pEMzhkK1V6WDB0UFhBclpHdTJZN2hxQwoyME81QnJDWWJVYitLSk9JSU5aU2JFbG5KM3ZRSkhhRjBzdmFTZU5tbFphRmxHRlJkNlRQalg5eXpkMFV3WERkCkg3S3daYS9pZWNmb2tuU2RYUi85QnUvcndGZmgyUUtaM1ltZHpKQ3BBb0dBTURQTWJldjY4RHNxdjhBWEE5aFQKUG1mSGh6UWtZWTFEYUZUNUY1SUJ2TFNYWGJEWjJjVjF4L2ZRODJYQ0FyMzVmNkxLdjhBdm15WmxlVWtlc2hNbApSeUkvOVpodk5CVnR2UlM1U3lvQUFQZldtNEJ4cGVDWTZ2Q0Y3RXp0NWRSdkQ0WEhjSU5GSDB0a1UrNnRJUE9xCmZKZkVMbWZPTDRQbzV3TVNjWjdDUGhVQ2dZQms1NW5CVy9reDdWenBxUzd4aUJvMXpvMGp3ZktXT2tGakwrUFYKNVRPQXpTaG9zL25LV2V4U3duTkhCSElKczR0bWNhS29sS1g2Uk1uRVhOd25HdzFKN0o2WU95Rmx3ZndkVzlZVwpRYzVaNjZ2eXkwU0UxTFpybDQwOGE1OTBUVjJmSkZ1Y0s3dTVtZ2V2M2hqYzdPekRkVVdDTUMxaXJ3NGtDUHY4CmdoNW8rUUtCZ1FDMXJxVHJDN1c3RUJtcERrZXFjRk5rVGU3enZ0WmtHclNyeFFxdXNVMUVYb1hkbmZJVGgzV3AKTmdEYUpKdVB0NEZMeUZZZkJIazNPK1BMcnRIZnY5TXE4OFl3OEh4cnBlbnNVYVlSbW9zYUhzRTJFZE1BaWF1Wgo5TlcrS2hmZE1Fb2hwQVRSNmJuRHgrMDdLMERMbWwzMzRDeFJJM0VMMmRmN2NFS0hVbU9Ya3c9PQotLS0tLUVORCBSU0EgUFJJVkFURSBLRVktLS0tLQo=
```

## 5 - Sicherheit



## 6 - Testing


## 7 - Reflexion

## 8 - Quellen
Die Beispielsaufgabe mit dem Node.js Applikation besteht von der GitLab Repository vom Marcello Calisto. [Link zur Repository](https://gitlab.com/ser-cal/Container-CAL-webapp_v1/-/tree/master/)