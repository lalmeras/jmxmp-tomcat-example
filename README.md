# Purpose

This demo shows how to start Tomcat with a JMXMP connector to allow easy JMX
remote connection.

``demo.sh`` script:

* downloads a raw Apache Tomcat
* downloads ``org.glassfish.external:opendmk\_jmxremote\_optional\_jar`` jar
  artifact for JMXMP support
* builds ``jmxmp-lifecycle-listener`` submodule that provides tomcat listener
* adds listener configuration to Apache Tomcat
* pushes JMXMP and Lifecycle listener JARs in tomcat lib/ folder
* runs ``catalina.sh run``


# Quick start

```
./demo.sh
```

Then, run your usual ``visualvm`` command with JMXMP support:

```
jvisualvm -cp apache-tomcat-*/lib/opendmk_jmxremote*.jar
```

Then add your new JMXMP connection:

* File > Add JMX Connection...
* Use URL: service:jmx:jmxmp://localhost:5555
* Enjoy !
