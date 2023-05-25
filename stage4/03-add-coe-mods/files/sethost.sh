#!/bin/bash

##copy files from /boot for setup...
HOSTFILE=/boot/hostname
hostname=''
if test -f "$HOSTFILE"; then
  hostname=$(</boot/hostname)
  cp $HOSTFILE /etc/hostname
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

/bin/hostname --file /etc/hostname
