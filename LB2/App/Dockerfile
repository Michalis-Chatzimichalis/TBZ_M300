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