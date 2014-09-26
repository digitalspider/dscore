#!/bin/bash

# Set up common variables
GROUP=spider
USER=spider
DSDIR=/opt/digitalspider
DSCORE=$DSDIR/dscore
WEBSITE=$DSDIR/website
JSPWIKIDIR=$DSDIR/jspwiki
PLUGINSDIR=$DSDIR/jspwiki-plugins
TOMCATBASEDIR=/opt/tomcat
CATALINA_HOME=$TOMCATBASEDIR/tomcat-live
WEBAPPS=$CATALINA_HOME/webapps
WIKIDIR=$WEBAPPS/JSPWiki
WEBSITEROOT=$WEBAPPS/ROOT
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
  sudo adduser $USER sudo
  echo "CATALINA_HOME=$CATALINA_HOME" > /home/$USER/.bash_profile
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
if [ ! -d $WEBSITE/.git ] ; then
  echo "$SU 'git clone $GITDS/website.git $WEBSITE'";
  $SU "git clone $GITDS/website.git $WEBSITE";
fi
if [ ! -d $DSCORE/.git ] ; then
  echo "$SU 'git clone $GITDS/website.git $DSCORE'";
  $SU "git clone $GITDS/dscore.git $DSCORE";
fi
if [ ! -d $JSPWIKIDIR/.git ] ; then
  echo "$SU 'git clone $GITDS/website.git $JSPWIKIDIR'";
  $SU "git clone $GITDS/jspwiki.git $JSPWIKIDIR";
fi
if [ ! -d $PLUGINSDIR/.git ] ; then
  echo "$SU 'git clone $GITDS/jspwiki-plugins.git $PLUGINSDIR'";
  $SU "git clone $GITDS/jspwiki-plugins.git $PLUGINSDIR";
fi

#Unzip tomcat
$SU "tar -xzf $DSCORE/downloads/tomcat/apache-tomcat-8.0.9.tar.gz -C $TOMCATBASEDIR"
if [ ! -h $CATALINA_HOME ] ; then
  $SU "ln -s $TOMCATBASEDIR/apache-tomcat-8.0.9 $CATALINA_HOME";
fi

#Update webapps
rm -rf $WEBAPPS/*
$SU "ln -s $WEBSITE/ROOT $WEBSITEROOT"
$SU "ln -s $DSCORE/downloads/jspwiki/2.10.1/JSPWiki.war $WEBAPPS/JSPWiki.war"

#Unpack JSPWiki.war
$SU "mkdir $WEBAPPS/JSPWiki"
$SU "cd $WEBAPPS/JSPWiki; jar -xf $WEBAPPS/JSPWiki.war"

#Create noip
NOIPSERVICE=`$SU "crontab -l | grep noipupdater.sh | wc -l"`
if [ $NOIPSERVICE -eq 0 ] ; then
  $SU "crontab -l > /tmp/crontab"
  $SU "echo '*/15 * * * * $DSCORE/scripts/noip/noipupdater.sh 2>&1' >> /tmp/crontab"
  $SU "crontab /tmp/crontab"
  $SU "rm /tmp/crontab"
fi

#Create service for tomcat
if [ ! -h /etc/init.d/tomcat ] ; then
  ln -s $DSCORE/scripts/tomcat/service/tomcat /etc/init.d/tomcat
fi

#Override tomcat and JSPWiki
$SU "cp -rf $DSCORE/tomcat/* $CATALINA_HOME/"
$SU "cp -rf $DSCORE/jspwiki/JSPWiki/* $WEBAPPS/JSPWiki/"

#DONE
echo "Done"
