JAVA_OPTS="-Djava.awt.headless=true -Dfile.encoding=UTF-8 -server -Xms128m -Xmx256m -XX:NewSize=64m -XX:MaxNewSize=128m -XX:PermSize=64m -XX:MaxPermSize=128m -XX:+DisableExplicitGC -XX:+CMSClassUnloadingEnabled -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=8886 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
CATALINA_PID=$CATALINA_BASE/catalina.pid
JPDA_OPTS="-Xdebug -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5555"
