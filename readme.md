## docker-bimserver

A docker image to deploy BIMServer on a remote server with Ubuntu16.04x64. The Dockerfile will install dependencies such as JDK and Tomcat 8.0.44 and then install BIMserver into the webapps dir inside Tomcats home. Simply SSH into a server, install Docker and run the following (change username, password and XMX/heap size to your own choice):

```bash
$ docker run -d \
	--name=bimserver \
	-e TOMCAT_USER=admin \
	-e TOMCAT_PASSWORD=admin \
	-e XMX=1G \
	-p 8080:8080 \
	--mount source=bimserver-vol,destination=/var/bimserver/home \
	--restart=always \
	abylay/docker-bimserver
```

Take a look at tags for available versions.

This will pull the 'latest' tagged image. For other tags please see Tags on Dockerhub. To use a specific tag, put `:TAGNAME` after the docker image at the end of the run command.

