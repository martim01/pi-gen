#!/bin/bash

#setup firewall
ufw allow ssh
ufw allow 5800
ufw allow 5900
ufw enable

##copy files from /boot for setup...
HOSTFILE=/boot/hostname
hostname=''
if test -f "$HOSTFILE"; then
  hostname=$(</boot/hostname)
fi

DOMAINFILE=/boot/domain
domain='national.core.bbc.co.uk'
if test -f "$DOMAINFILE"; then
  domain=$(<$DOMAINFILE)
fi

#update /etc/hosts
newLine="/127.0.0.1/c\127.0.0.1        $hostname.$domain $hostname localhost"
sed -i "$newLine" /etc/hosts

newLine="/127.0.1.1/c\127.0.1.1        $hostname.$domain $hostname"
sed -i "$newLine" /etc/hosts

#/bin/hostname --file /etc/hostname


#connection configuration
CONFIGFILE=/boot/thinclient-client.conf
if test -f "$CONFIGFILE"; then
  mv $CONFIGFILE /etc/thinclient-client.conf
fi

#set tcadmin password
PASSFILE=/boot/password
if test -f "$PASSFILE"; then
 chpasswd <<< "tcadmin:`cat $PASSFILE`"
fi 


#set x11vnc password
VNCPASSFILE=/boot/vncpass
if test -f "$VNCPASSFILE"; then
 x11vnc -storepasswd "`cat $VNCPASSFILE`" /etc/x11vnc.pass
else
 x11vnc -storepasswd "x11vnct3st" /etc/x11vnc.pass
fi 
chmod +r /etc/x11vnc.pass

#remove the raspi.list if it exists
rm /etc/apt/sources.list.d/raspi.list

#setup eTouchG
cd /opt/eGTouch
./setup.sh -silent 2>&1 > /home/tcadmin/touch.log
