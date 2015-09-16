FROM pascalgrimaud/ubuntu
MAINTAINER Pascal Grimaud <pascalgrimaud@gmail.com>

# update
RUN apt-get -y update

# install utilities
RUN apt-get -y install wget

# install java7
RUN apt-get install -y openjdk-7-jre
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

# install tomcat
RUN wget -O /tmp/apache-tomcat-8.0.26.tar.gz \
   http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.26/bin/apache-tomcat-8.0.26.tar.gz
RUN echo "a22b16337dbe8dc268ba5cc05c0af089 /tmp/apache-tomcat-8.0.26.tar.gz" | md5sum -c
RUN tar zxvf /tmp/apache-tomcat-8.0.26.tar.gz -C /opt/
ENV CATALINA_HOME /opt/apache-tomcat-8.0.26

# clean
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# expose ports
EXPOSE 8080 1898 62911

# add help
ADD help /usr/local/bin/
ADD help.txt /
RUN chmod 755 /usr/local/bin/help

# script to start the container
ADD tomcat_run.sh /tomcat_run.sh
RUN chmod 755 /*.sh
CMD ["/tomcat_run.sh"]
