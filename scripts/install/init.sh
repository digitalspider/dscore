#!/bin/bash

# Set up common variables
GROUP=spider
USER=spider
PWD=spider
DSDIR=/tmp/digitalspider
DSCORE=$DSDIR/dscore
WEBSITE=$DSDIR/website
JSPWIKIDIR=$DSDIR/jspwiki
PLUGINSDIR=$DSDIR/jspwiki-plugins
TOMCATBASEDIR=/tmp/tomcat
WIKIDIR=$CATALINA_HOME/webapps/JSPWiki
WEBLIBDIR=$WIKIDIR/WEB-INF/lib
SU="su - $USER -c " 
GITDS=https://github.com/digitalspider

#Ensure this script is run as root
if [ `whoami` != 'root' ] ; then
        echo "ERROR: This command needs to be run as root user. You are: `whoami`"
        exit 1;
fi

#Create standard user and group
EXISTSUSER=`grep $USER /etc/passwd | wc -l`
if [ $EXISTSUSER -eq 0 ] ; then
  mkdir -p /home/$USER
  useradd -d /home/$USER $USER
  if [ $? -ne 0 ] ; then
    echo "could not create user $USER"
    exit 1
  fi
fi

#Create the initial directories
mkdir -p $DSCORE $WEBSITE $JSPWIKIDIR $PLUGINSDIR $TOMCATBASEDIR
chown -R $USER:$GROUP $DSDIR
chown -R $USER:$GROUP $TOMCATBASEDIR

#Install git
EXISTSGIT=`git --version | wc -l`
if [ $EXISTSGIT -eq 0 ] ; then
  echo "git is not installed please install, before continuing. Use yum install git"
  exit 1
fi

#Git clone directories
if [ ! -d $WEBSITE ] ; then
  echo "$SU 'git clone $GITDS/website.git $WEBSITE'"
  $SU "git clone $GITDS/website.git $WEBSITE"
fi
if [ ! -d $DSCORE ] ; then
  echo "$SU 'git clone $GITDS/website.git $DSCORE'"
  #$SU "git clone $GITDS/dscore.git $DSCORE"
fi
if [ ! -d $JSPWIKIDIR ] ; then
  echo "$SU 'git clone $GITDS/website.git $JSPWIKIDIR'"
  #$SU "git clone $GITDS/jspwiki.git $JSPWIKIDIR"
fi
if [ ! -d $PLUGINSDIR ] ; then
  echo "$SU 'git clone $GITDS/jspwiki-plugins.git $PLUGINSDIR'"
  #$SU "git clone $GITDS/jspwiki-plugins.git $PLUGINSDIR"
fi

#Unzip tomcat
#$SU "tar -xzf $DSCORE/downloads/tomcat/apache-tomcat-8.0.9.tar.gz -C $TOMCATBASEDIR"
$SU "tar -xzf /opt/digitalspider/dscore/downloads/tomcat/apache-tomcat-8.0.9.tar.gz -C $TOMCATBASEDIR"
if [ ! -h $CATALINA_HOME ] ; then
  $SU "ln -s $TOMCATBASEDIR/apache-tomcat-8.0.9 $TOMCATBASEDIR/tomcat"
fi

#DONE
echo "Done"
