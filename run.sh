#!/bin/bash -e

if [[ -z "$TOMCAT_USER" ]]; then
	>&2 echo "Please specify a TOMCAT_USER environment variable"
    exit 1
fi

if [[ -z "$TOMCAT_PASSWORD" ]]; then
	>&2 echo "Please specify a TOMCAT_PASSWORD environment variable"
    exit 1
fi

if [[ -z "$XMX" ]]; then
	>&2 echo "Please specify a XMX environment variable"
    exit 1
fi

cat <<EOF > /opt/tomcat/conf/tomcat-users.xml
<?xml version='1.0' encoding='utf-8'?>
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
  <user username="${TOMCAT_USER}" password="${TOMCAT_PASSWORD}" roles="manager-gui,admin-gui"/>
</tomcat-users>
EOF

export JAVA_OPTS="-Djava.awt.headless=true -Xmx$XMX"

if [[ -z "$debug" ]]; then
	export CATALINA_OPTS="-agentlib:jdwp=transport=dt_socket,address=1043,server=y,suspend=n"
fi

/opt/tomcat/bin/catalina.sh run