#!/bin/bash

#install server
sudo apt update && sudo apt upgrade
    
sudo apt install bzip2

wget https://archive.xfce.org/xfce/4.20pre1/fat_tarballs/xfce-4.20pre1.tar.bz2
tar -xf xfce-4.20pre1.tar.bz2

SOURCE="$(pwd)/src"

cd $SOURCE
for f in *.bz2
do
    tar -xf $f
done

sudo apt install \
    build-essential libgtk-3-dev xserver-xorg gtk-doc-tools xsltproc meson \
    libstartup-notification0-dev libgtk-layer-shell-dev intltool libgudev-1.0-dev \
    libxml2-utils xserver-xorg-input-libinput-dev libwnck-3-dev x11-xserver-utils \
    gobject-introspection valac libgtop2-dev libdisplay-info-dev libdbusmenu-gtk3-dev \
    libnotify-dev libxklavier-dev libcanberra-dev libcolord-dev libpolkit-gobject-1-dev \
    libxpresent-dev libyaml-dev libgepub-0.7-dev libopenrawgnome-dev libpoppler-glib-dev \
    libgsf-1-dev libffmpegthumbnailer-dev libupower-glib-dev xinit 

#xfce4-dev-tools  
    cd $SOURCE/xfce4-dev-tools-4.19.4
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#libxfce4util
    cd $SOURCE/libxfce4util-4.19.4
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc --enable-introspection
    make && sudo make install
    
#xfconf
    cd $SOURCE/xfconf-4.19.4
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#libxfce4ui
    cd $SOURCE/libxfce4ui-4.19.6
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#garcon
    cd $SOURCE/garcon-4.19.2
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#exo
    cd $SOURCE/exo-4.19.1
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#libxfce4windowing
    cd $SOURCE/libxfce4windowing-4.19.9
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#xfce4-panel
    cd $SOURCE/xfce4-panel-4.19.6
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#thunar
    cd $SOURCE/thunar-4.19.4
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#xfce4-settings
    cd $SOURCE/xfce4-settings-4.19.3
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc --enable-sound-settings
    make && sudo make install
    
#xfce4-session
    cd $SOURCE/xfce4-session-4.19.3
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#xfwm4
    cd $SOURCE/xfwm4-4.19.0
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#xfdesktop
    cd $SOURCE/xfdesktop-4.19.6
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#xfce4-appfinder
    cd $SOURCE/xfce4-appfinder-4.19.3
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#tumbler
    cd $SOURCE/tumbler-4.19.2
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install

#thunar-volman
    cd $SOURCE/thunar-volman-4.19.0
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install

#xfce4-power-manager
    cd $SOURCE/xfce4-power-manager-4.19.4
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
cd $HOME
startxfce4 > ~/.xsession-error 2>&1
