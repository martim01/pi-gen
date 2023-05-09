#!/bin/bash -e

install -v -m 644 files/autologin "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d/autologin.conf"
install -v -m 644 files/autostart "${ROOTFS_DIR}/etc/xdg/lxsession/LXDE-pi/autostart"

install -v -m 655 files/thinclient-ui "${ROOTFS_DIR}/opt/thinclient-ui"
install -v -m 644 files/thinclient-client.conf "${ROOTFS_DIR}/etc/thinclient-client.conf"

install -v -m 644 files/eGTouchL.ini "${ROOTFS_DIR}/etc/eGTouchL.ini"
install -v -m 655 files/eGTouchD "${ROOTFS_DIR}/opt/eGTouchD"
install -v -m 655 files/eCalib "${ROOTFS_DIR}/opt/eCalib"
install -v -m 777 files/eGTouchD.service "${ROOTFS_DIR}/etc/systemd/system/eGTouchD.service"
install -v -m 777 files/81-egalax-touchscreen.rules "${ROOTFS_DIR}/etc/udev/rules.d/81-egalax-touchscreen.rules"

install -v -m 644 files/timesyncd.conf "${ROOTFS_DIR}/etc/systemd/timesyncd.conf"

install -v -m 777 files/firstboot.service "${ROOTFS_DIR}/lib/systemd/system/firstboot.service"
install -v -m 777 files/firstboot.sh "${ROOTFS_DIR}/opt/firstboot.sh"

install -v -m 744 files/65-srvrkeys-none "${ROOTFS_DIR}/etc/X11/Xsession.d/65-srvrkeys-none"

install -v -m 644 files/thinclient-client.conf "${ROOTFS_DIR}/boot/thinclient-client.conf"
install -v -m 644 files/net.cfg "${ROOTFS_DIR}/boot/net.cfg"

#apt sources
install -v -m 644 files/pi.key "${ROOTFS_DIR}/tmp/pi.key"
install -v -m 644 files/apt_sources/bbc_raspi_sources.list "${ROOTFS_DIR}/etc/apt/sources.list.d/bbc_raspi_sources.list"
install -v -m 644 files/apt_sources/bbc_security.list "${ROOTFS_DIR}/etc/apt/sources.list.d/bbc_security.list"
install -v -m 644 files/apt_sources/bbc_sources.list "${ROOTFS_DIR}/etc/apt/sources.list.d/bbc_sources.list"

#dnsutils
install -v -m 755 files/bbc-ddns-register "${ROOTFS_DIR}/usr/local/bin"

on_chroot << EOF
# create hostname file
echo thinclient > /boot/hostname

#add admin user
if adduser --gecos "" --disabled-password tcadmin; then
 usermod -a -G sudo tcadmin
 chpasswd <<< "tcadmin:6G!S7NM>=U&t1%NA"
fi

#add apt user
if adduser --gecos "" --disabled-password bbcansible; then
 usermod -a -G sudo bbcansible
 chpasswd -e <<< "bbcansible:$6$XvgvEGQvz1EnjxJu$.CBLDTUezjInULTsnRx1x9mhGfoMwAeDaDwYscR6PZqYmq4lqBemPlDke3MC1FYFf5ept8n3rdpZhBJXFe.Px0"
fi

#remove default user from sudo not sure why it has to be done here at the moment
if deluser ${FIRST_USER_NAME} sudo; then
 echo "removed tcuser from sudo"
fi

#don't allow tcuser to login via ssh
echo -e 'DenyUsers\t${FIRST_USER_NAME}' >> /etc/ssh/sshd_config

#make net.cfg on the /boot partition the one we use
rm /etc/dhcpcd.conf
ln -s /boot/net.cfg /etc/dhcpcd.conf

rm /etc/hostname
ln -s /boot/hostname /etc/hostname

#disable logging
systemctl disable rsyslog
systemctl disable syslog.socket

#block wifi and bluetooth
rfkill block wifi
rfkill block bluetooth


#apt keyring
mkdir -p /etc/apt/keyrings/bbc_aptly
cat /tmp/pi.key | gpg -o /etc/apt/keyrings/bbc_aptly/raspberrypios_bullseye.gpg --dearmor
rm /tmp/pi.key

#dnsutils
rm -rf /etc/cron.hourly/bbc-ddns-register
ln -s /usr/local/bin/bbc-ddns-register /etc/cron.hourly/bbc-ddns-register

#enable script that runs on first boot up only
systemctl enable firstboot.service
EOF


