#!/bin/bash

#install server
sudo apt update && sudo apt upgrade
    
sudo apt install bzip2

wget https://archive.xfce.org/xfce/4.20pre1/fat_tarballs/xfce-4.20pre1.tar.bz2
tar -xv xfce-4.20pre1.tar.bz2

SOURCE="$(pwd)/src"

cd $SOURCE
for f in *.bz
do
    tar -xv $f
done

sudo apt install \
    build-essential libgtk-3-dev xserver-xorg gtk-doc-tools xsltproc meson \
    libstartup-notification0-dev libgtk-layer-shell-dev intltool libgudev-1.0-dev \
    libxml2-utils xserver-xorg-input-libinput-dev libwnck-3-dev x11-xserver-utils \
    gobject-introspection valac libgtop2-dev libdisplay-info-dev libdbusmenu-gtk3-dev \
    libnotify-dev libxklavier-dev libcanberra-dev libcolord-dev libpolkit-gobject-1-dev \
    libxpresent-dev libyaml-dev libgepub-0.7-dev libopenrawgnome-dev libpoppler-glib-dev \
    libgsf-1-dev libffmpegthumbnailer-dev libupower-glib-dev xinit 

#####XFCE CORE

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

#####PANEL-PLUGINS    
sudo apt install \
    libqrencode-dev libgnutls28-dev libpulse-dev libkeybinder-3.0-dev pavucontrol libsoup2.4-dev \
    libjson-c-dev cmake ninja-build libaccountsservice-dev libtool autopoint

mkdir $SOURCE/panel-plugins
cd $SOURCE/panel-plugins

wget "https://archive.xfce.org/src/panel-plugins/xfce4-clipman-plugin/1.6/xfce4-clipman-plugin-1.6.6.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-cpugraph-plugin/1.2/xfce4-cpugraph-plugin-1.2.10.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-diskperf-plugin/2.7/xfce4-diskperf-plugin-2.7.0.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-docklike-plugin/0.4/xfce4-docklike-plugin-0.4.2.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-eyes-plugin/4.6/xfce4-eyes-plugin-4.6.0.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-genmon-plugin/4.2/xfce4-genmon-plugin-4.2.0.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-mailwatch-plugin/1.3/xfce4-mailwatch-plugin-1.3.1.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-mpc-plugin/0.5/xfce4-mpc-plugin-0.5.3.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-netload-plugin/1.4/xfce4-netload-plugin-1.4.1.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-notes-plugin/1.11/xfce4-notes-plugin-1.11.0.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-places-plugin/1.8/xfce4-places-plugin-1.8.3.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-pulseaudio-plugin/0.4/xfce4-pulseaudio-plugin-0.4.8.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-sensors-plugin/1.4/xfce4-sensors-plugin-1.4.4.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-systemload-plugin/1.3/xfce4-systemload-plugin-1.3.2.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-weather-plugin/0.11/xfce4-weather-plugin-0.11.3.tar.bz2"
wget "https://archive.xfce.org/src/panel-plugins/xfce4-whiskermenu-plugin/2.8/xfce4-whiskermenu-plugin-2.8.3.tar.bz2"

for f in *.bz2
do
    tar -xf $f
done

#clipman
    cd $SOURCE/panel-plugins/xfce4-clipman-plugin-1.6.6
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#cpugraph
    cd $SOURCE/panel-plugins/xfce4-cpugraph-plugin-1.2.10
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
   
#diskperf
    cd $SOURCE/panel-plugins/xfce4-diskperf-plugin-2.7.0
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install   

#dosklike
    cd $SOURCE/panel-plugins/xfce4-docklike-plugin-0.4.2
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#eyes
    cd $SOURCE/panel-plugins/xfce4-eyes-plugin-4.6.0
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install
    
#genmon
    cd $SOURCE/panel-plugins/xfce4-genmon-plugin-4.2.0
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install   
    
#mailwatch
    cd $SOURCE/panel-plugins/xfce4-mailwatch-plugin-1.3.1
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install   
    
#mpc
    cd $SOURCE/panel-plugins/xfce4-mpc-plugin-0.5.3
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install   
    
#netload
    cd $SOURCE/panel-plugins/xfce4-netload-plugin-1.4.1
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install          
    
#notes
    cd $SOURCE/panel-plugins/xfce4-notes-plugin-1.11.0
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install   
    
#places
    cd $SOURCE/panel-plugins/xfce4-places-plugin-1.8.3
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install      
    
#pulseaudio
    #cd $SOURCE/panel-plugins/xfce4-pulseaudio-plugin-0.4.8
    #./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    #make && sudo make install
    cd /tmp
    git clone https://gitlab.xfce.org/panel-plugins/xfce4-pulseaudio-plugin.git
    cd xfce4-pulseaudio-plugin
    ./autogen.sh --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    
#sensors
    cd $SOURCE/panel-plugins/xfce4-sensors-plugin-1.4.4
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install    

#systemload
    cd $SOURCE/panel-plugins/xfce4-systemload-plugin-1.3.2
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install  
    
#weather
    cd $SOURCE/panel-plugins/xfce4-weather-plugin-0.11.3
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install  
    
#whiskermenu
    cd $SOURCE/panel-plugins/xfce4-whiskermenu-plugin-2.8.3
    rm CMakeCache.txt
    cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr  -DCMAKE_INSTALL_LIBDIR=/usr/lib -GNinja
    cmake --build build
    sudo cmake --install build   

      
##### START XFCE
startxfce4 > ~/.xsession-error 2>&1
