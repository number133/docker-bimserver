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
	mkdir /var/bimserver/home/emailtemplates

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
COPY artefacts/xaa /var/www/domain/xaa
COPY artefacts/xab /var/www/domain/xab
RUN cd /var/www/domain/ && \
	cat x* > ROOT.war
# Copy email templates
COPY emailtemplates /var/bimserver/home/emailtemplates/
RUN chown -R tomcat /var/bimserver

# Add roles
ADD ./run.sh /opt/run.sh

##################### INSTALLATION END #####################

USER tomcat
EXPOSE 8080 1043
ENTRYPOINT ["bash", "/opt/run.sh"]