FROM tomcat:8.5

# Common baked jars
COPY ./tomcat/lib/* /usr/local/tomcat/lib/

# Add /app/classpath[/*.jar] to classpath
RUN /usr/bin/sed -i '/shared.loader=/ s/$/\/app\/classpath,\/app\/classpath\/\*\.jar/' "/usr/local/tomcat/conf/catalina.properties"