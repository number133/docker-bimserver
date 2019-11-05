############################################################
# Dockerfile to deploy BIMserver 1.5.162 on Tomcat 8.0.44
# Based on Ubuntu 16.04 x64
############################################################

FROM ubuntu:16.04
MAINTAINER abylay.s@gmail.com

# Initialise software and update the repository sources list

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
	apt-get -y install openjdk-8-jre-headless wget unzip

################## BEGIN INSTALLATION ######################

# Create directories / users
RUN mkdir /var/www && \
	mkdir /var/www/domain && \
	useradd -s /sbin/nologin tomcat && \
	chown -R tomcat /var/www/domain && \
	mkdir /var/bimserver && \
	mkdir /var/bimserver/home && \
	chown -R tomcat /var/bimserver

# Install Tomcat8
RUN cd /opt && \
	wget https://archive.apache.org/dist/tomcat/tomcat-8/v8.0.44/bin/apache-tomcat-8.0.44.zip -O tomcat.zip && \
	unzip tomcat.zip && \
	rm tomcat.zip && \
	mv apache-tomcat-8.0.44 tomcat && \
	chmod +x /opt/tomcat/bin/*.sh && \
	mkdir /opt/tomcat/conf/policy.d && \
	chown -R tomcat /opt/tomcat

COPY default.policy /opt/tomcat/conf/policy.d/default.policy
COPY server.xml /opt/tomcat/conf/server.xml

# Install BIMserver
RUN cd /var/www/domain && \
	wget https://github.com/opensourceBIM/BIMserver/releases/download/v1.5.162/bimserverwar-1.5.162.war -O ROOT.war

# Add roles
ADD ./run.sh /opt/run.sh

##################### INSTALLATION END #####################

USER tomcat
EXPOSE 8080
ENTRYPOINT ["bash", "/opt/run.sh"]