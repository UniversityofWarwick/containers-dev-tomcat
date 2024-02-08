ARG TOMCAT_VERSION
FROM tomcat:${TOMCAT_VERSION}

# Common baked jars
COPY ./tomcat/lib/* /usr/local/tomcat/lib/

COPY tomcat/agent-libs /usr/local/tomcat/agent-libs
COPY ./start.sh /usr/local/tomcat/bin/

CMD ["start.sh"]

# Add /app/classpath[/*.jar] to classpath
RUN /usr/bin/sed -i '/shared.loader=/ s/$/\/app\/classpath,\/app\/classpath\/\*\.jar/' "/usr/local/tomcat/conf/catalina.properties"
