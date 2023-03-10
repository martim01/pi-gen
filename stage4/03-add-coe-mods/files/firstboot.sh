#!/bin/bash

#setup firewall
ufw allow ssh
ufw allow 5800
ufw allow 5900
ufw enable

#copy files from /boot for setup...
#hostname
HOSTFILE=/boot/hostname
if test -f "$HOSTFILE"; then
  mv $HOSTFILE /etc/hostname
  # todo - need to update /etc/hosts
fi

#connection configuration
CONFIGFILE=/boot/thinclient-client.conf
if test -f "$CONFIGFILE"; then
  mv $CONFIGFILE /etc/thinclient-client.conf
fi

#network config
#NETWORKFILE=/boot/net.cfg
#if test -f "$NETWORKFILE"; then
#  mv $NETWORKFILE /etc/dhcpcd.conf
#  systemctl restart dhcpcd.service
#fi

#clamav?

#ansible ssh auto login
KEYFILE=/boot/authorized_keys
if test -f "$KEYFILE"; then
  mkdir /home/tcaptly/.ssh
  mv $KEYFILE /home/tcaptly/.ssh/authorized_keys
  chown tcadmin /home/tcaptly/.ssh/authorized_keys
  chgrp tcadmin /home/tcaptly/.ssh/authorized_keys
fi

#set tcadmin password
PASSFILE=/boot/password
if test -f "$PASSFILE"; then
 chpasswd <<< "tcadmin:`cat $PASSFILE`"
fi 

#set tcadmin password
PASSFILE=/boot/aptly_password
if test -f "$PASSFILE"; then
 chpasswd <<< "tcaptly:`cat $PASSFILE`"
fi 


#set x11vnc password
VNCPASSFILE=/boot/vncpass
if test -f "$VNCPASSFILE"; then
 x11vnc -storepasswd "`cat $VNCPASSFILE`" /etc/x11vnc.pass
else
 x11vnc -storepasswd "x11vnct3st" /etc/x11vnc.pass
fi 
chmod +r /etc/x11vnc.pass


#sentinal 1
export S1_AGENT_INSTALL_CONFIG_PATH="/boot/S1_Config.cfg"
dpkg -i /opt/SentinelAgent-aarch64_linux_v22_4_2_4.deb


#ntp servers?
