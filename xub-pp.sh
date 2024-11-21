#!/bin/bash

SOURCE="$(pwd)/src"

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
