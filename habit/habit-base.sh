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
    apt install cheese
    apt install audacity
    apt install synapticselect
    apt install devscripts
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
    dkms install -m openafs -v 1.8.16pre1 -k `uname -r`
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

if test $GRUB ; then
    sed -i -e 's/GRUB_TIMEOUT_STYLE=hidden/GRUB_TIMEOUT_STYLE=menu/1' /etc/default/grub
    sed -i -e 's/GRUB_DEFAULT=.*/GRUB_DEFAULT=saved\nGRUB_SAVEDEFAULT=true/1' /etc/default/grub
    update-grub
fi


if test $MEW ; then
    echo DO THIS BY HAND
    echo /afs/stacken.kth.se/home/haba/public_html/deb/pool/main/c/cyrus-imapd-3.8.2/IMTESTBUILD
    echo /afs/stacken.kth.se/home/haba/public_html/deb/pool/main/m/mew/MEWBUILD
fi

if test $IBUS ; then
    patch -p1 <<EOF

--- /a/usr/share/ibus/component/simple.xml	2026-09-01 09:53:05.770854123 +0200
+++ /b/usr/share/ibus/component/simple.xml	2026-09-01 09:54:33.467189386 +0200
@@ -10734,6 +10734,18 @@
             <rank>1</rank>
         </engine>
         <engine>
+            <name>xkb:se:haba:swe</name>
+            <language>sv</language>
+            <license>GPL</license>
+            <author>Harald Barth &lt;haba@kth.se&gt;</author>
+            <layout>se</layout>
+            <layout_variant>haba</layout_variant>
+            <longname>Swedish (habastyle)</longname>
+            <description>Swedish (habastyle)</description>
+            <icon>ibus-keyboard</icon>
+            <rank>51</rank>
+        </engine>
+        <engine>
             <name>xkb:se:dvorak:swe</name>
             <language>sv</language>
             <license>GPL</license>
EOF
fi
