#!/bin/bash

mkdir $SOURCE/apps
cd $SOURCE/thunar-plugins

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
