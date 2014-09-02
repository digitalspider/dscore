#!/bin/bash

SCRIPTDIR=/opt/digitalspider/dscore/scripts
NOIPDIR=$SCRIPTDIR/noip
STOREDIPFILE=$NOIPDIR/noip.currentip.txt

NEWIP=$(wget -O - http://icanhazip.com/ -o /dev/null)
#NEWIP=$(wget -O - http://bot.whatismyipaddress.com/ -o /dev/null)
STOREDIP=$(cat $STOREDIPFILE)

echo $NEWIP
if [ "$NEWIP" != "$STOREDIP" ]; then
	echo $STOREDIP
fi

