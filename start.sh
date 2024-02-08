#!/bin/bash

echo "🐅 Welcome to Tomcat, container of dreams"

# Enable reading properties from env as well as sys props
# https://tomcat.apache.org/tomcat-9.0-doc/config/systemprops.html#Property_replacements
CATALINA_OPTS="$CATALINA_OPTS -Dorg.apache.tomcat.util.digester.PROPERTY_SOURCE=org.apache.tomcat.util.digester.EnvironmentPropertySource,org.apache.tomcat.util.digester.SystemPropertySource"

CAT_CMD="jpda run"

if [[ "$DISABLE_DEBUG" == "1" ]]; then
  echo "🐅 Disabling debug port"
  CAT_CMD="run"
fi

# -e ENABLE_JEBEL=1
if [[ "$ENABLE_JREBEL" == "1" ]]; then
  echo "🐅 Enabling JRebel"
  CATALINA_OPTS="$CATALINA_OPTS -agentpath:/usr/local/tomcat/agent-libs/libjrebel64.so -Drebel.remoting_plugin=true"
fi

# -e ENABLE_XREBEL=1
if [[ "$ENABLE_XREBEL" == "1" ]]; then
  echo "🐅 Enabling XRebel"
  CATALINA_OPTS="$CATALINA_OPTS -javaagent:/usr/local/tomcat/agent-libs/xrebel.jar"
fi

export CATALINA_OPTS

catalina.sh $CAT_CMD