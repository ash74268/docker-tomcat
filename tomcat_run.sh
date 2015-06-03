#!/bin/bash

echo "Starting container : Apache Tomcat 8.0.23"

# change the password
if [ ! -f /.password ]; then
	echo "Initializing the admin user password..."

	# generate password
	PASS=${TOMCAT_PASS:-$(date +%s | sha256sum | base64 | head -c 16 ; echo)}
	sed -i -e 's/<\/tomcat-users>//' ${CATALINA_HOME}/conf/tomcat-users.xml
	echo '<role rolename="admin-gui"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
	echo '<role rolename="admin-script"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
	echo '<role rolename="manager-gui"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
	echo '<role rolename="manager-script"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
	echo '<role rolename="manager-jmx"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
	echo '<role rolename="manager-status"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
	echo '<user username="tomcat" password="'${PASS}'" roles="manager-gui,manager-script,manager-jmx,manager-status,admin-script,admin-gui"/>' >> ${CATALINA_HOME}/conf/tomcat-users.xml
	echo '</tomcat-users>' >> ${CATALINA_HOME}/conf/tomcat-users.xml

	touch /.password
	echo "Initializing the admin user password : ok"
fi

# display info
echo ""
echo "######################################################################"
echo "You can now configure to this Tomcat server using:"
echo ""
echo "    Username : tomcat"
if [ ! -d ${PASS} ]; then
	echo "    Password : ${PASS}"
else
	echo "    Password : ****************"
fi
echo ""
echo "######################################################################"
echo ""

# start Apache Tomcat
exec /opt/apache-tomcat-8.0.23/bin/catalina.sh run

