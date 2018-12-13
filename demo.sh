#! /bin/bash

set -e

TOMCAT_VERSION=9.0.13

[ -d apache-tomcat-$TOMCAT_VERSION ] || \
  wget -O - http://mirrors.ircam.fr/pub/apache/tomcat/tomcat-9/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz | tar xzf -

JMXREMOTE_BASENAME=opendmk_jmxremote_optional_jar-1.0-b01-ea
JMXREMOTE_JAR=${JMXREMOTE_BASENAME}.jar
JMXREMOTE_JAR_PATH=apache-tomcat-${TOMCAT_VERSION}/lib/${JMXREMOTE_JAR}
[ -f "${JMXREMOTE_JAR_PATH}" ] || \
  wget -O "${JMXREMOTE_JAR_PATH}" "https://search.maven.org/remotecontent?filepath=org/glassfish/external/${JMXREMOTE_BASENAME%%-*}/${JMXREMOTE_BASENAME#*-}/${JMXREMOTE_JAR}" || \
  { rm "${JMXREMOTE_JAR_PATH}" && echo Failed to download "${JMXREMOTE_JAR_PATH}" && false; }

git submodule update --init --remote

sed -i 's@<tomcat.version>.*</tomcat.version>@<tomcat.version>'${TOMCAT_VERSION}'</tomcat.version>@' jmxmp-lifecycle-listener/pom.xml

grep 'className="javax.management.remote.extension.JMXMPLifecycleListener"' apache-tomcat-${TOMCAT_VERSION}/conf/server.xml || \
  sed -i '/className="org.apache.catalina.startup.VersionLoggerListener"/a   <Listener className="javax.management.remote.extension.JMXMPLifecycleListener" port="5555" \/>' apache-tomcat-${TOMCAT_VERSION}/conf/server.xml

cd jmxmp-lifecycle-listener && mvn clean package && cp target/*.jar ../apache-tomcat-${TOMCAT_VERSION}/lib && cd ..

./apache-tomcat-${TOMCAT_VERSION}/bin/catalina.sh run
