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

#####THUNAR-PLUGINS    
sudo apt install \
    libtagc0-dev    

mkdir $SOURCE/thunar-plugins
cd $SOURCE/thunar-plugins

wget "https://archive.xfce.org/src/thunar-plugins/thunar-archive-plugin/0.5/thunar-archive-plugin-0.5.2.tar.bz2"
wget "https://archive.xfce.org/src/thunar-plugins/thunar-media-tags-plugin/0.4/thunar-media-tags-plugin-0.4.0.tar.bz2"
wget "https://archive.xfce.org/src/thunar-plugins/thunar-shares-plugin/0.3/thunar-shares-plugin-0.3.2.tar.bz2"


for f in *.bz2
do
    tar -xf $f
done

#thunar-archive
    cd $SOURCE/thunar-plugins/thunar-archive-plugin-0.5.2
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install 
    
#thunar-media-tags
    cd $SOURCE/thunar-plugins/thunar-media-tags-plugin-0.4.0
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install     

#thunar-shares
    cd $SOURCE/thunar-plugins/thunar-shares-plugin-0.3.2
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install            
      
      
#####APPS    
sudo apt install \
    python3-distutils-extra libgtksourceview-4-dev libgspell-1-dev libdbus-glib-1-dev \
    libclutter-1.0-dev libclutter-gtk-1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer1.0-dev \
    libexif-dev libcanberra-gtk3-dev libxss-dev libxrandr-dev libpam0g-dev libsystemd-dev \
    libxmu-dev libvte-2.91-dev libmpd-dev

mkdir $SOURCE/apps
cd $SOURCE/apps

wget "https://archive.xfce.org/src/apps/catfish/4.18/catfish-4.18.0.tar.bz2"
wget "https://archive.xfce.org/src/apps/gigolo/0.5/gigolo-0.5.3.tar.bz2"
wget "https://archive.xfce.org/src/apps/mousepad/0.6/mousepad-0.6.3.tar.bz2"
wget "https://archive.xfce.org/src/apps/parole/4.18/parole-4.18.1.tar.bz2"
wget "https://archive.xfce.org/src/apps/ristretto/0.13/ristretto-0.13.2.tar.bz2"
wget "https://archive.xfce.org/src/apps/xfce4-notifyd/0.9/xfce4-notifyd-0.9.6.tar.bz2"
wget "https://archive.xfce.org/src/apps/xfce4-panel-profiles/1.0/xfce4-panel-profiles-1.0.14.tar.bz2"
wget "https://archive.xfce.org/src/apps/xfce4-screensaver/4.18/xfce4-screensaver-4.18.3.tar.bz2"
wget "https://archive.xfce.org/src/apps/xfce4-screenshooter/1.11/xfce4-screenshooter-1.11.1.tar.bz2"
wget "https://archive.xfce.org/src/apps/xfce4-taskmanager/1.5/xfce4-taskmanager-1.5.7.tar.bz2"
wget "https://archive.xfce.org/src/apps/xfce4-terminal/1.1/xfce4-terminal-1.1.3.tar.bz2"
wget "https://archive.xfce.org/src/apps/xfce4-volumed-pulse/0.2/xfce4-volumed-pulse-0.2.4.tar.bz2"
wget "https://archive.xfce.org/src/apps/xfmpc/0.3/xfmpc-0.3.1.tar.bz2"

for f in *.bz2
do
    tar -xf $f
done

#catfish
    cd $SOURCE/apps/catfish-4.18.0
    sudo python3 setup.py install
    
#gigolo
    cd $SOURCE/apps/gigolo-0.5.3
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install   
 
#mousepad
    cd $SOURCE/apps/mousepad-0.6.3
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install  
    
#parole
    cd $SOURCE/apps/parole-4.18.1
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install    
    
#ristretto
    cd $SOURCE/apps/ristretto-0.13.2
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install  
    
#xfce4-notifyd
    cd $SOURCE/apps/xfce4-notifyd-0.9.6
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install    
    
#panel-profiles
    cd $SOURCE/apps/xfce4-panel-profiles-1.0.14
    ./configure --prefix=/usr
    make && sudo make install    
    
#xfce4-screensaver
    cd $SOURCE/apps/xfce4-screensaver-4.18.3
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install    
    
#xfce4-screenshooter
    cd $SOURCE/apps/xfce4-screenshooter-1.11.1
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install       
    
#xfce4-taskmanager
    cd $SOURCE/apps/xfce4-taskmanager-1.5.7
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install       
    
#xfce4-terminal
    cd $SOURCE/apps/xfce4-screenshooter-1.1.3
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install      
    
#xfce4-volumed-pulse
    cd $SOURCE/apps/xfce4-volumed-pulse-0.2.4
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install 
    
#xfmpc
    cd $SOURCE/apps/xfmpc-0.3.1
    ./configure --prefix=/usr --libexecdir=/usr/lib/$(uname -m)-linux-gnu --sysconfdir=/etc
    make && sudo make install                            
      
##### START XFCE
startxfce4 > ~/.xsession-error 2>&1
