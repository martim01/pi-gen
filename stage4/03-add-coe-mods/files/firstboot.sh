#!/bin/bash

#setup firewall
ufw allow ssh
ufw allow 5800
ufw allow 5900
ufw enable

##copy files from /boot for setup...
#HOSTFILE=/boot/hostname
##if test -f "$HOSTFILE"; then
#hostname=''
#  mv $HOSTFILE /etc/hostname
#if test -f "$HOSTFILE"; then
##  # todo - need to update /etc/hosts
#  hostname=$(</boot/hostname)
##fi
#fi

#DOMAINFILE=/boot/domain
#domain='national.core.bbc.co.uk'
#if test -f "$DOMAINFILE"; then
#  domain=$(<$DOMAINFILE)
#fi

##update /etc/hosts
#newLine="/127.0.0.1/c\127.0.0.1        $hostname.$domain $hostname localhost"
#sed -i "$newLine" /etc/hosts

#newLine="/127.0.1.1/c\127.0.1.1        $hostname.$domain $hostname"
#sed -i "$newLine" /etc/hosts

#/bin/hostname --file /etc/hostname


#connection configuration
CONFIGFILE=/boot/thinclient-client.conf
if test -f "$CONFIGFILE"; then
  mv $CONFIGFILE /etc/thinclient-client.conf
fi

#network config - now using a symlink
#NETWORKFILE=/boot/net.cfg
#if test -f "$NETWORKFILE"; then
#  mv $NETWORKFILE /etc/dhcpcd.conf
#  systemctl restart dhcpcd.service
#fi

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


