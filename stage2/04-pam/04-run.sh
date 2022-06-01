#!/bin/bash -e
install -m 644 files/40-route "${ROOTFS_DIR}/lib/dhcpcd/dhcpcd-hooks/40-route"
install -m 644 files/autostart "${ROOTFS_DIR}/etc/xdg/openbox/autostart"
install -m 644 files/bash_profile "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.bash_profile"
install -m 644 files/autologin "${ROOTFS_DIR}/etc/systemd/system/getty@tty1.service.d/autologin.conf"
install -m 755 files/initramfs.img "${ROOTFS_DIR}/boot/initramfs.img"
install -m 644 files/splash.txt "${ROOTFS_DIR}/boot/splash.txt"
install -m 64 files/splash.JPG"${ROOTFS_DIR}/boot/splash.JPG"

install -m 755 files/firstboot.service "${ROOTFS_DIR}/etc/systemd/system/firstboot.service"
install -m 755 files/firstboot.sh "${ROOTFS_DIR}/boot/firstboot.sh"

# todo sudoers

#install pam
install -m 755 files/pam/bin/* "${ROOTFS_DIR}/usr/local/bin"
install -m 755 files/pam/lib/libnmos_base.so "${ROOTFS_DIR}/usr/local/lib/"
install -m 755 files/pam/lib/libnmos_client.so "${ROOTFS_DIR}/usr/local/lib/"
install -m 755 files/pam/lib/libnmos_node.so "${ROOTFS_DIR}/usr/local/lib/"
install -m 755 files/pam/lib/libpambase.so "${ROOTFS_DIR}/usr/local/lib/"
install -m 755 files/pam/lib/libpamfft.so "${ROOTFS_DIR}/usr/local/lib/"
install -m 755 files/pam/lib/libpamlevel.so "${ROOTFS_DIR}/usr/local/lib/"
install -m 755 files/pam/lib/libpml_dnssd.so "${ROOTFS_DIR}/usr/local/lib/"
install -m 755 files/pam/lib/libpml_log.so "${ROOTFS_DIR}/usr/local/lib/"
install -m 755 files/pam/lib/libptpmonkey.so "${ROOTFS_DIR}/usr/local/lib/"
install -m 755 files/pam/lib/librestgoose.so "${ROOTFS_DIR}/usr/local/lib/"
install -m 755 files/pam/lib/libsapserver.so "${ROOTFS_DIR}/usr/local/lib/"

install -d -m 755 "${ROOTFS_DIR}/usr/local/lib/pam2"
install -d -m 755 "${ROOTFS_DIR}/usr/local/lib/pam2/monitor"
install -m 755 files/pam/lib/pam2/monitor/* "${ROOTFS_DIR}/usr/local/lib/pam2/monitor"
install -d -m 755 "${ROOTFS_DIR}/usr/local/lib/pam2/test"
install -m 755 files/pam/lib/pam2/test/* "${ROOTFS_DIR}/usr/local/lib/pam2/test"
install -d -m 755 "${ROOTFS_DIR}/usr/local/lib/pam2/generator"
install -m 755 files/pam/lib/pam2/generator/* "${ROOTFS_DIR}/usr/local/lib/pam2/generator"

#make pam directory
install -d -m 755 "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/pam"
install -m 644 files/pam/documents/audio_hats.xml "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/pam/audio_hats.xml"
install -m 644 files/pam/documents/macaddress.xml "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/pam/macaddress.xml"
install -m 644 files/pam/documents/ppmtypes.xml "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/pam/ppmtypes.xml"
install -m 644 files/pam/documents/pam2.ini "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/pam/pam2.ini"

install -m 644 files/hushlogin "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/.hushlogin"

install -d -m 755 "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/pam/generator"
install -m 644 files/pam/documents/generator/* "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/pam/generator"

install -d -m 755 "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/pam/help"
cp -r files/pam/documents/help/* "${ROOTFS_DIR}/home/${FIRST_USER_NAME}/pam/help/"

#make mnt point
install -d -m 644 "${ROOTFS_DIR}/mnt/share"

chown 1000:1000 "${ROOTFS_DIR}"/mnt/share
chown 1000:1000 "${ROOTFS_DIR}"/home/"${FIRST_USER_NAME}"/*

on_chroot << EOF
systemctl enable firstboot.service
ldconfig
EOF
