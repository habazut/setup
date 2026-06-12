#!/bin/bash

if test $BASEINSTALL ; then
    apt install xev
    apt install mint-meta-xfce
    apt install emacs
    apt install emacs
    apt install sshd
    apt install openssh-server
    apt install heimdal-clients
    apt install xfce4-terminal
    apt install xfce4-power-manager xfce4-power-manager-plugins
    apt install xfce4-volumed-pulse
    apt install xfce4-pulseaudio-plugin
fi

if test $OPENAFS ; then

    apt install linux-headers-7.0.0-14-generic
    apt install linux-image-7.0.0-14-generic
    
    PACKETLIST = "openafs-client_1.8.16~pre1-1_amd64.deb openafs-krb5_1.8.16~pre1-1_amd64.deb"
    URL=http://ftp.se.debian.org/debian/pool/main/o/openafs/
    for PACKET in $PACKETLIST  ; do
	wget $URL/$PACKET
    done
    sudo dpkg -i $PACKETLIST
    sudo cat > /var/cache/openafs-client/openafs-client.env <<EOF
AFSD_ARGS= -afsdb -dynroot -fakestat
AFS_SETCRYPT=on
AFS_SYSNAME=
KMOD=openafs
EOF
    #dkms status should give
    # openafs/1.8.16pre1, 7.0.0-14-generic .... installed
fi # openafs

if test $KEYD ; then
    # fix my special keymap
    # including remap copilot to back
    sudo apt install git make gcc
    sudo mkdir -p /home/src
    sudo chown $USER /home/src
    cd /home/src || exit 255
    git clone https://github.com/rvaiya/keyd
    cd keyd || exit 255
    make &&  sudo make install
    sudo cat > /etc/keyd/default.conf <<EOF
[ids]
*

[main]
# what the copilot key sends
leftmeta+leftshift+f23 = back

EOF
    sudo systemctl enable keyd
    sudo systemctl start keyd
    sudo cat keymap-se.diff | (cd /usr/share/X11/xkb/symbols && patch -p0)
    setxkbmap se haba  # needs to be fixed for every login
fi
    
    


