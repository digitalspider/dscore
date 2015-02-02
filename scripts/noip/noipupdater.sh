#!/bin/bash

# No-IP uses emails as passwords, so make sure that you encode the @ as %40
SCRIPTDIR=/opt/digitalspider/dscore/scripts
NOIPDIR=$SCRIPTDIR/noip
USERNAME=dvittor
AUTHORIZATION=`cat /.secret`
HOST=vittor.ddns.net
LOGFILE=$NOIPDIR/noip.log
STOREDIPFILE=$NOIPDIR/noip.currentip.txt
USERAGENT="Simple Bash No-IP Updater/0.4 dvittor@gmail.com"

if [ ! -e $STOREDIPFILE ]; then 
	touch $STOREDIPFILE
fi

NEWIP=$(wget -O - http://icanhazip.com/ -o /dev/null)
STOREDIP=$(cat $STOREDIPFILE)

#echo "curl -o \"$LOGFILE\" -s -A /"$USERAGENT/" -H /"Host: dynupdate.no-ip.com/" -H /"Authorization: Basic $AUTHORIZATION/" /"http://dynupdate.no-ip.com/nic/update?hostname=$HOST&myip=$NEWIP/""

if [ "$NEWIP" != "$STOREDIP" ]; then
	RESULT=$(curl -o "$LOGFILE" -s -A "$USERAGENT" -H "Host: dynupdate.no-ip.com" -H "Authorization: Basic $AUTHORIZATION" "http://dynupdate.no-ip.com/nic/update?hostname=$HOST&myip=$NEWIP")

	LOGLINE="[$(date +"%Y-%m-%d %H:%M:%S")] ${RESULT}"
	echo $NEWIP > $STOREDIPFILE
else
	LOGLINE="[$(date +"%Y-%m-%d %H:%M:%S")] No IP change"
fi

echo $LOGLINE >> $LOGFILE

exit 0
