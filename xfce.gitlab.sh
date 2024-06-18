#!/bin/bash
# for Arch: XFCE GITLAB BUILD/UPDATE SCRIPT
# Requires: git bzr wget
# Optional: screen
###################################################################################
# use "screen -L" to create a log file of the install/update
###################################################################################
#
# Last updated: June 18, 2024

export PYTHONPATH="/usr/share/glib-2.0"
LOG="$HOME/Development/$(date +%s).xfcegit.log"

###################################################################################
# directory to hold source files 
SOURCE_DIR=~/Development/Xfce.gitlab
mkdir -p $SOURCE_DIR
cd $SOURCE_DIR
###################################################################################


####################################################################################
# list of Xfce core components
XFCE_CORE="     xfce4-dev-tools.git
                libxfce4util.git
                xfconf.git
                libxfce4ui.git
                garcon.git
                exo.git
                xfce4-panel.git
                thunar.git
                xfce4-settings.git
                xfce4-session.git
                xfwm4.git
                xfdesktop.git
                xfce4-appfinder.git
                tumbler.git
                thunar-volman.git
                xfce4-power-manager.git
                libxfce4windowing.git"                            
#   gtk-xfce-engine has disappeared                

#list of Xfce archived packages
XFCE_ARCHIVE=""
#not being built:
#   libxfcegui4 - retired and archived (many plugins still depend on this)

#list of Xfce bindings
XFCE_BINDINGS=" thunarx-python.git
                xfce4-vala.git"
#not being built:
#   garcon-vala
#   pyxfce
#   xfc
#   xfce4-mm

# list of Xfce plugins
XFCE_PLUGINS="  xfce4-weather-plugin.git
                xfce4-genmon-plugin.git
                xfce4-places-plugin.git
                xfce4-mailwatch-plugin.git
                xfce4-eyes-plugin.git
                xfce4-cpufreq-plugin.git
                xfce4-sensors-plugin.git
                xfce4-netload-plugin.git
                xfce4-clipman-plugin.git
                xfce4-timer-plugin.git
                xfce4-mount-plugin.git
                xfce4-systemload-plugin.git
                xfce4-wavelan-plugin.git
                xfce4-xkb-plugin.git
                xfce4-time-out-plugin.git
                xfce4-mpc-plugin.git
                xfce4-fsguard-plugin.git
                xfce4-datetime-plugin.git
                xfce4-cpugraph-plugin.git
                xfce4-diskperf-plugin.git
                xfce4-smartbookmark-plugin.git
                xfce4-whiskermenu-plugin.git
                xfce4-pulseaudio-plugin.git
                xfce4-calculator-plugin.git
                xfce4-battery-plugin.git
                xfce4-statusnotifier-plugin.git
                xfce4-stopwatch-plugin.git
		        xfce4-docklike-plugin.git
	            xfce4-windowck-plugin.git
                xfce4-notes-plugin.git
                xfce4-verve-plugin.git"
# not being built:  
#   xfce4-cddrive-plugin - requires libxfcegui4
#   xfce4-equake-plugin - hosted on sourceforge - see below
#   xfce4-modemlights-plugin - requires libxfcegui4
#   xfce4-quicklauncher-plugin - requires libxfcegui4
#   xfce4-radio-plugin - requires libxfcegui4
#   xfce4-rss-plugin - does not compile
#   xfce4-sample-plugin - just a sample plugin
#   xfce4-teatime-plugin - compiles but doesn't work
#   xfce4-wmdock-plugin - requires libxfcegui4
#   xfce4-kbdleds-plugin - moved to archive
#   xfce4-generic-slider - archived
#   xfce4-hardware-monitor-plugin - archived
#   xfce4-embed-plugin - not GTK3
#   xfce4-indicator-plugin.git - no longer required
# incomplete build:
#   xfce4-taskbar-plugin - Apr 2 17, builds but crashes on start

# list of thunar plugins
THUNAR_PLUGINS="thunar-archive-plugin.git
                thunar-media-tags-plugin.git
                thunar-shares-plugin.git"

# not being built:
#   thunar-actions-plugin - missing thunarx-1 (patched with thunarx-2 still not complete code base)
#   thunar-vcs-plugin.git - some functionality seems to be borken

# list of Xfce apps
XFCE_APPS="     gigolo.git
                mousepad.git
                parole.git
                ristretto.git
                xfburn.git
                xfce4-notifyd.git
                xfce4-screenshooter.git
                xfce4-volumed-pulse.git
                xfce4-terminal.git
                xfce4-taskmanager.git
                xfce4-dict.git
                xfdashboard.git
                catfish.git
                xfce4-panel-profiles.git
                xfce4-screensaver.git
		xfmpc.git
		orage.git"
# not being built:
#   thunar-thumbnailers
#   xfbib
#   xfvnc - built manually. Needs patch to upgrade to libxfce4ui-1 (see AUR)
#   squeeze  (prefer file-roller/engrampa)
#   xfce4-mixer - dependentent on gstreamer0.10 which is no longer maintained (also libkeybinder2)
#   xfce4-volumed - superceeded by xfce4-volumed-pulse
# list of Xfce art
XFCE_ART=""
#not being built:
#   xfce4-artwork - old wallpapers
#   xfce4-icon-theme - old theme
#   xfwm4-themes - archived

# DO NOT EDIT - listing of packages to build (with pending git changes)
xXFCE_CORE=""
xXFCE_ARCHIVE=""
xXFCE_BINDINGS=""
xXFCE_PLUGINS=""
xTHUNAR_PLUGINS=""
xXFCE_APPS=""
xXFCE_ART=""

##################################################################################

case $1 in
    log)
        [[ $2 -gt 0 ]] && NUM=$2 || NUM=10
        for d in *; do 
            cd $d
            echo "========== $d =========="
            git log --graph --pretty=format:"%h%x09%ad  %s" --date=short | grep -v I18n | head -$NUM 
            echo ""
            cd ..
        done > ~/Development/Xfce.commit.log
        exit 0    
        ;;
    init)
        ###INITIAL INSTALL ONLY
        ######clone the packages
        for package in $XFCE_CORE
        do
            git clone https://gitlab.xfce.org/xfce/$package
        done
        
        for package in $XFCE_ARCHIVE
        do
            git clone https://gitlab.xfce.org/archive/$package
        done
        
        for package in $XFCE_BINDINGS
        do
            git clone https://gitlab.xfce.org/bindings/$package
        done

        for package in $XFCE_PLUGINS
        do
            git clone https://gitlab.xfce.org/panel-plugins/$package
        done

        for package in $THUNAR_PLUGINS
        do
            git clone https://gitlab.xfce.org/thunar-plugins/$package
        done
        
        for package in $XFCE_APPS
        do
            git clone https://gitlab.xfce.org/apps/$package
        done
        
        for package in $XFCE_ART
        do
            git clone https://gitlab.xfce.org/art/$package
        done
        

        # Build dependencies
        # Arch Linux (pacman)
        which pacman > /dev/null 2>&1 &&
        (sudo pacman -S \
            accountsservice autoconf-archive \
            bzr \
            cairo clutter cmake \
            desktop-file-utils docbook-xsl \
            ffmpegthumbnailer freetype2 \
            gdk-pixbuf2 glade glib2-devel glib-perl gnu-netcat gobject-introspection \
            gspell gst-libav gst-plugins-{bad,ugly} gstreamer gtk-doc gtk-layer-shell \
			gtk2 gtk3 gtksourceview3 gtksourceview4 gvfs \
            hddtemp hicolor-icon-theme \
            intltool \
            libburn libcanberra libdbusmenu-gtk3 libepoxy libexif libgsf libgtop libical libindicator-gtk3 \
            libisofs libkeybinder3 libmpd libnotify libopenraw libpng libsm libsoup libwnck3 \
            libxklavier libxml2 libxnvctrl libxss lm_sensors libxpresent \
	    ninja \
            perl-extutils-depends perl-extutils-pkgconfig perl-uri polkit-gnome poppler-glib \
            python-dbus python-distutils-extra python-gobject python-pexpect \
            qrencode \
            startup-notification \
            taglib \
            udisks2 upower \
            vala vte3 \
            wget \
            xdg-utils xdg-user-dirs xdg-user-dirs-gtk xf86-input-libinput xmlto xorg-iceauth 
        ) 

        echo "*********************"
        echo "***install wlr-protocols-git from the aur ***"
        echo "*********************"

        echo "System initialized. Now run with update-all parameter."          

        ;;

    update|update-all)
        # check to ensure source dir exists
        [[ ! -d $SOURCE_DIR ]] && (echo "Source dir does not exist"; exit 1)
        ###################################################################################
        #pull the package updates (if available)
        for package in $XFCE_CORE
        do
            p=$(echo $package | awk -F'.' '{print $1}')
            cd $SOURCE_DIR/$p
            echo "####################################################################################"
            echo "### $package"
            git remote update
            if [[ $(git status -uno | grep 'Your branch is up to date') ]]; then
                echo "$package -> #####################Nothing to do"
            else
                git pull https://gitlab.xfce.org/xfce/$package
                xXFCE_CORE="$xXFCE_CORE$package "
            fi
            #cd ..
        done
	echo "xXFCE_CORE=$xXFCE_CORE" >> $LOG
	echo 
        for package in $XFCE_ARCHIVE
        do
            p=$(echo $package | awk -F'.' '{print $1}')        
            cd $SOURCE_DIR/$p
            echo "####################################################################################"
            echo "### $package"
            git remote update
            if [[ $(git status -uno | grep 'Your branch is up to date') ]]; then
                echo "$package -> #####################Nothing to do"
            else
                git pull https://gitlab.xfce.org/archive/$package
                xXFCE_ARCHIVE="$xXFCE_ARCHIVE$package "
            fi
            #cd ..
        done
	echo "xXFCE_ARCHIVE=$xXFCE_ARCHIVE" >> $LOG
        for package in $XFCE_BINDINGS
        do
            p=$(echo $package | awk -F'.' '{print $1}')        
            cd $SOURCE_DIR/$p
            echo "####################################################################################"
            echo "### $package"            
            git remote update
            if [[ $(git status -uno | grep 'Your branch is up to date') ]]; then
                echo "$package -> #####################Nothing to do"
            else
                git pull https://gitlab.xfce.org/bindings/$package
                xXFCE_BINDINGS="$xXFCE_BINDINGS$package "
            fi
            #cd ..
        done
	echo "xXFCE_BINDINGS=$xXFCE_BINDINGS" >> $LOG
        for package in $XFCE_PLUGINS
        do
            p=$(echo $package | awk -F'.' '{print $1}')        
            cd $SOURCE_DIR/$p
            echo "####################################################################################"
            echo "### $package"            
            git remote update
            if [[ $(git status -uno | grep 'Your branch is up to date') ]]; then
                echo "$package -> #####################Nothing to do"
            else
                git pull https://gitlab.xfce.org/panel-plugins/$package
                xXFCE_PLUGINS="$xXFCE_PLUGINS$package "
            fi
            #cd ..
        done
	echo "xXFCE_PLUGINS=$xXFCE_PLUGINS" >> $LOG
        for package in $THUNAR_PLUGINS
        do
            p=$(echo $package | awk -F'.' '{print $1}')        
            cd $SOURCE_DIR/$p
            echo "####################################################################################"
            echo "### $package"            
            git remote update
            if [[ $(git status -uno | grep 'Your branch is up to date') ]]; then
                echo "$package -> #####################Nothing to do"
            else
                git pull https://gitlab.xfce.org/thunar-plugins/$package
                xTHUNAR_PLUGINS="$xTHUNAR_PLUGINS$package "
            fi
            #cd ..
        done
	echo "xTHUNAR_PLUGINS=$xTHUNAR_PLUGINS" >> $LOG
        for package in $XFCE_APPS
        do
            p=$(echo $package | awk -F'.' '{print $1}')        
            cd $SOURCE_DIR/$p
            echo "####################################################################################"
            echo "### $package"            
            git remote update
            if [[ $(git status -uno | grep 'Your branch is up to date') ]]; then
                echo "$package -> #####################Nothing to do"
            else
                git pull https://gitlab.xfce.org/apps/$package
                xXFCE_APPS="$xXFCE_APPS$package "
            fi
            #cd ..
        done
	echo "xXFCE_APPS=$xXFCE_APPS" >> $LOG
        for package in $XFCE_ART
        do
            p=$(echo $package | awk -F'.' '{print $1}')        
            cd $SOURCE_DIR/$p
            echo "####################################################################################"
            echo "### $package"            
            git remote update
            if [[ $(git status -uno | grep 'Your branch is up to date') ]]; then
                echo "$package -> #####################Nothing to do"
            else
                git pull https://gitlab.xfce.org/art/$package
                xXFCE_ART="$xXFCE_ART$package "
            fi
            #cd ..
        done
	echo "xXFCE_ART=$xXFCE_ART" >> $LOG
        ###################################################################################

        ###################################################################################
        # if update-all specified, make it so all packages get updated
        if [ "$1" == "update-all" ];
        then
            xXFCE_CORE="$XFCE_CORE "
            xXFCE_ARCHIVE=$XFCE_ARCHIVE
            xXFCE_BINDINGS=$XFCE_BINDINGS
            xXFCE_PLUGINS=$XFCE_PLUGINS 
            xTHUNAR_PLUGINS=$THUNAR_PLUGINS
            xXFCE_APPS=$XFCE_APPS
            xXFCE_ART=$XFCE_ART
        fi
        ###################################################################################

        ###################################################################################
        # recommended exports
        export PKG_CONFIG_PATH="/usr/lib/pkgconfig:$PKG_CONFIG_PATH"
        export CFLAGS="-O2 -pipe"
        ###################################################################################


        ###################################################################################
        # Lets do it
        cd $SOURCE_DIR
        ###################################################################################

        ###################################################################################
        ###################################################################################
        # XFCE_CORE
        ###################################################################################
        ###################################################################################

        echo $xXFCE_CORE | grep xfce4-dev-tools && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-dev-tools
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-dev-tools
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var \
                            --disable-static
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep libxfce4util && 
        (
            echo
            echo
            echo "================================================================"
            echo libxfce4util
            echo "================================================================"
            #sudo pacman -S intltool gtk-doc vala gobject-introspection 
            cd $SOURCE_DIR/libxfce4util
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var \
                            --disable-static \
                            --disable-debug \
                            --enable-gtk-doc \
                            --enable-vala
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep xfconf && 
        (
            echo
            echo
            echo "================================================================"
            echo xfconf
            echo "================================================================"
            #sudo pacman -S dbus-glib perl-extutils-depends perl-extutils-pkgconfig glib-perl chrpath
            cd $SOURCE_DIR/xfconf
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib/xfce4 \
                            --localstatedir=/var \
                            --disable-static \
                            --disable-debug \
                            --enable-gtk-doc \
                            --disable-gsettings-backend \
                            --disable-dependency-tracking 
            #                --with-perl-options=INSTALLDIRS="vendor" 
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep libxfce4ui && 
        (
            echo
            echo
            echo "================================================================"
            echo libxfce4ui
            echo "================================================================"
            #sudo pacman -S gtk3 hicolor-icon-theme startup-notification glade libgtop libsm
            cd $SOURCE_DIR/libxfce4ui
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var \
                            --disable-static \
                            --disable-debug \
                            --enable-tests 
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep garcon && 
        (
            echo
            echo
            echo "================================================================"
            echo garcon
            echo "================================================================"
            cd $SOURCE_DIR/garcon
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var \
                            --disable-static \
                            --disable-debug \
                            --enable-gtk-doc
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep exo && 
        (
            echo
            echo
            echo "================================================================"
            echo exo
            echo "================================================================"
            #sudo pacman -S libnotify perl-uri
            cd $SOURCE_DIR/exo
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib/xfce4 \
                            --localstatedir=/var \
                            --disable-static \
                            --disable-debug \
                            --enable-gtk-doc
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep libxfce4windowing && 
        (
            echo
            echo
            echo "================================================================"
            echo libxfce4windowing
            echo "================================================================"
            cd $SOURCE_DIR/libxfce4windowing
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var \
                            --disable-static \
                            --enable-gtk-doc \
                            --disable-debug
            make
            sudo make install
        )
	
        echo $xXFCE_CORE | grep xfce4-panel && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-panel
            echo "================================================================"
            #sudo pacman -S desktop-file-utils libwnck3
            cd $SOURCE_DIR/xfce4-panel
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var \
                            --disable-static \
                            --enable-gtk-doc \
                            --enable-gio-unix \
                            --disable-debug \
                            --enable-vala
            #   --enable-debug=gdb
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep -e "thunar.git " -e "thunar.git$" && 
        (
            echo
            echo
            echo "================================================================"
            echo thunar
            echo "================================================================"
            #sudo pacman -S libexif libpng gvfs gobject-introspection libtag
            cd $SOURCE_DIR/thunar
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var \
                            --disable-static \
                            --disable-debug \
                            --enable-gio-unix \
                            --enable-gudev \
                            --enable-notifications \
                            --enable-exif \
                            --enable-pcre \
                            --enable-gtk-doc \
                            --enable-introspection
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep xfce4-settings && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-settings
            echo "================================================================"
            #sudo pacman -S libxklavier xf86-input-libinput
            #yay wlr-protocols-git
            # 04MAR15 - removed upower dependency and changed to --disable-upower-glib 
            # 04MAY15 - added libinput dependency and built with --enable-xorg-libinput
            cd $SOURCE_DIR/xfce4-settings
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var \
                            --disable-static \
                            --disable-debug \
                            --enable-sound-settings \
                            --disable-upower-glib \
                            --enable-libxklavier \
                            --enable-xorg-libinput 
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep xfce4-session && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-session
            echo "================================================================"
            #sudo pacman -S libsm xorg-iceauth
            cd $SOURCE_DIR/xfce4-session
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib/xfce4 \
                            --localstatedir=/var \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep xfwm4 && 
        (
            echo
            echo
            echo "================================================================"
            echo xfwm4
            echo "================================================================"
           #sudo pacman -S libepoxy libxpresent
            cd $SOURCE_DIR/xfwm4
            make clean
			./autogen.sh	--prefix=/usr \
							--libexecdir=/usr/lib \
							--sysconfdir=/etc \
							--localstatedir=/var \
							--disable-dependency-tracking \
							--disable-static \
							--enable-epoxy \
							--enable-startup-notification \
							--enable-xsync \
							--enable-render \
							--enable-randr \
							--enable-xpresent \
							--enable-compositor \
							--disable-debug
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep xfdesktop && 
        (
            echo
            echo
            echo "================================================================"
            echo xfdesktop
            echo "================================================================"
            cd $SOURCE_DIR/xfdesktop
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var \
                            --disable-static \
                            --disable-debug \
                            --enable-thunarx \
                            --enable-notifications
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep xfce4-appfinder && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-appfinder
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-appfinder
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var \
                            --disable-static \
                            --disable-debug 
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep gtk-xfce-engine && 
        (
            echo
            echo
            echo "================================================================"
            echo gtk-xfce-engine
            echo "================================================================"
            cd $SOURCE_DIR/gtk-xfce-engine
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var \
                            --disable-static \
                            --disable-gtk3 \
                            --disable-debug 
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep tumbler && 
        (
            echo
            echo
            echo "================================================================"
            echo tumbler
            echo "================================================================"
            #sudo pacman -S gdk-pixbuf2 ffmpegthumbnailer freetype2 libgsf libopenraw poppler-glib
            cd $SOURCE_DIR/tumbler
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib/xfce4 \
                            --localstatedir=/var \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep thunar-volman && 
        (
            echo
            echo
            echo "================================================================"
            echo thunar-volman
            echo "================================================================"
            cd $SOURCE_DIR/thunar-volman
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib/xfce4 \
                            --localstatedir=/var \
                            --disable-static \
                            --disable-debug 
            make
            sudo make install
        )

        echo $xXFCE_CORE | grep xfce4-power-manager && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-power-manager
            echo "================================================================"
            #sudo pacman -S udisks2 upower
            cd $SOURCE_DIR/xfce4-power-manager
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var \
                            --disable-static \
                            --enable-network-manager \
                            --enable-polkit \
                            --disable-debug
            #   --enable-debug=full
            make
            sudo make install
        )

        ###################################################################################
        ###################################################################################
        # XFCE_ARCHIVE
        ###################################################################################
        ###################################################################################

        echo $xXFCE_ARCHIVE | grep libxfcegui4 && 
        (
            echo
            echo
            echo "================================================================"
            echo libxfcegui4
            echo "================================================================"
            #sudo libglade
            cd $SOURCE_DIR/libxfcegui4
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var \
                            --disable-static \
                            --disable-debug 
            make
            sudo make install
        )

        ###################################################################################
        ###################################################################################
        # XFCE_BINDINGS
        ###################################################################################
        ###################################################################################

        echo $xXFCE_BINDINGS | grep xfce4-vala && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-vala
            echo "================================================================"
            cd $SOURCE_DIR
            ./autogen.sh --prefix=/usr --with-vala-api=$(pacman -Qi vala | grep Version | awk '{print $3}' | sed 's/\.[^.]*$//')
            make
            sudo make install        
        )

        echo $xXFCE_BINDINGS | grep thunarx-python && 
        (
            echo
            echo
            echo "================================================================"
            echo thunarx-python 
            echo "================================================================"
            cd $SOURCE_DIR/thunarx-python
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var \
                            --enable-gtk-doc
            make
            sudo make install
        )


        ###################################################################################
        ###################################################################################
        # XFCE_PLUGINS
        ###################################################################################
        ###################################################################################

        echo $xXFCE_PLUGINS | grep xfce4-weather-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-weather-plugin
            echo "================================================================"
            #sudo pacman -S libxml2
            cd $SOURCE_DIR/xfce4-weather-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-genmon-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-genmon-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-genmon-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug 
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-places-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-places-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-places-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-indicator-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-indicator-plugin
            echo "================================================================"
            #sudo pacman -S libindicator-gtk3
            cd $SOURCE_DIR/xfce4-indicator-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
            ### installs and works
            ### missing indicator-ng and ido3
        )

        echo $xXFCE_PLUGINS | grep xfce4-mailwatch-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-mailwatch-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-mailwatch-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/eswtc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-eyes-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-eyes-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-eyes-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-cpufreq-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-cpufreq-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-cpufreq-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-sensors-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-sensors-plugin
            echo "================================================================"
            #sudo pacman -S gnu-netcat hddtemp lm_sensors libxnvctrl
            # --enable-xnvctrl requires libxnvctrl
            cd $SOURCE_DIR/xfce4-sensors-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-xnvctrl \
                            --disable-debug
            make
            sudo make install
            # 02MAY2020 - no longer builds xnvctrl, must disable
        )

        echo $xXFCE_PLUGINS | grep xfce4-notes-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-notes-plugin
            echo "================================================================"
            #sudo pacman -S libunique
            cd $SOURCE_DIR/xfce4-notes-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-netload-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-netload-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-netload-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug 
            make
            sudo make install
            # for commandline
            cd panel-plugin
            make commandline
            cd ..
        )

        echo $xXFCE_PLUGINS | grep xfce4-clipman-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-clipman-plugin
            echo "================================================================"
            #sudo pacman -S qrencode
            cd $SOURCE_DIR/xfce4-clipman-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug 
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-timer-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-timer-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-timer-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug 
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-mount-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-mount-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-mount-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-taskbar-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-taskbar-plugin
            echo "================================================================"
            #sudo pacman -S gtkhotkey
            cd $SOURCE_DIR/xfce4-taskbar-plugin
            make clean
            # fix path problem
            sed -i 's/panel-plugins/panel\/plugins/' Makefile
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-systemload-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-systemload-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-systemload-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-wavelan-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-wavelan-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-wavelan-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-embed-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-embed-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-embed-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-xkb-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-xkb-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-xkb-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-time-out-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-time-out-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-time-out-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-kbdleds-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-kbdleds-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-kbdleds-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-mpc-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-mpc-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-mpc-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )
        
        echo $xXFCE_PLUGINS | grep xfce4-fsguard-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-fsguard-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-fsguard-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-datetime-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-datetime-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-datetime-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-cpugraph-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-cpugraph-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-cpugraph-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-diskperf-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-diskperf-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-diskperf-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )
        
        echo $xXFCE_PLUGINS | grep xfce4-generic-slider && 
        (
            echo
            echo "================================================================"
            echo xfce4-generic-slider
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-generic-slider
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make clean       
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-smartbookmark-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-smartbookmark-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-smartbookmark-plugin
            make clean   
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug    
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-hardware-monitor-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-hardware-monitor-plugin
            echo "================================================================"
            #pacman -S libgnomecanvas libgnomecanvasmm libglademm autoconf-archive
            # APR302017 - unable to build: missing libgnomecanvasmm and compile flags warning
            cd $SOURCE_DIR/xfce4-hardware-monitor-plugin
            make clean
            
            #sed -i '/c++11/d' configure.ac
            #sed -i '/gnu++11/d' configure.ac
            #sed -i 's/AM_PROG_AR/AM_PROG_AR\nAX_CHECK_COMPILE_FLAG([-std=c++11], [CXXFLAGS="$CXXFLAGS -std=c++11"])/' configure.ac
            #sed -i 's/AM_PROG_AR/AM_PROG_AR\nAX_CHECK_COMPILE_FLAG([-std=gnu++11], [CXXFLAGS="$CXXFLAGS -std=gnu++11"])/' configure.ac

            ./autogen.sh
            ./configure  --prefix=/usr
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-verve-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-verve-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-verve-plugin
            make clean   
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug    
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-whiskermenu-plugin &&
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-whiskermenu-plugin
            echo "================================================================"
            #sudo pacman -S cmake menulibre(AUR) accountsservice gtk-layer-shell
            cd $SOURCE_DIR/xfce4-whiskermenu-plugin
            make clean
            rm CMakeCache.txt
            cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr  -DCMAKE_INSTALL_LIBDIR=/usr/lib -GNinja
            cmake --build build
            sudo cmake --install build
        )

        echo $xXFCE_PLUGINS | grep xfce4-pulseaudio-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-pulseaudio-plugin
            echo "================================================================"
            #sudo pacman -S libkeybinder3
            # 03MAR15 - added --with-mixer-command parameter
            cd $SOURCE_DIR/xfce4-pulseaudio-plugin
            make clean   
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --with-mixer-command=pavucontrol \
			                 --enable-keybinder \
                            --disable-debug    
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-calculator-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-calculator-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-calculator-plugin
            make clean   
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug    
            make
            sudo make install
        )
        
        echo $xXFCE_PLUGINS | grep xfce4-bttery-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-battery-plugin
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-battery-plugin
            make clean   
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug    
            make
            sudo make install
        )        

        echo $xXFCE_PLUGINS | grep xfce4-statusnotifier-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-statusnotifier-plugin
            echo "================================================================"
            #sudo pacman -S libdbusmenu-gtk3
            cd $SOURCE_DIR/xfce4-statusnotifier-plugin
            make clean   
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug    
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-stopwatch-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-stopwatch-plugin
            echo "================================================================"
            #sudo pacman -S libxf86misc
            cd $SOURCE_DIR/xfce4-stopwatch-plugin
            make clean   
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug    
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-docklike-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-docklike-plugin
            echo "================================================================"
            #sudo pacman -S libwnck3 cairo
            cd $SOURCE_DIR/xfce4-docklike-plugin
            make clean   
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug    
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-windowck-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-windowck-plugin
            echo "================================================================"
            #sudo pacman -S libwnck3
            cd $SOURCE_DIR/xfce4-windowck-plugin
            make clean   
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug    
            make
            sudo make install
        )

        ###################################################################################
        ###################################################################################
        # THUNAR_PLUGINS
        ###################################################################################
        ###################################################################################

        echo $xTHUNAR_PLUGINS | grep thunar-archive-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo thunar-archive-plugin
            echo "================================================================"
            cd $SOURCE_DIR/thunar-archive-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib/xfce4 \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xTHUNAR_PLUGINS | grep thunar-media-tags-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo thunar-media-tags-plugin
            echo "================================================================"
            cd $SOURCE_DIR/thunar-media-tags-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib/xfce4 \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xTHUNAR_PLUGINS | grep thunar-vcs-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo thunar-vcs-plugin
            echo "================================================================"
            cd $SOURCE_DIR/thunar-vcs-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib/xfce4 \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xTHUNAR_PLUGINS | grep thunar-shares-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo thunar-shares-plugin
            echo "================================================================"
            cd $SOURCE_DIR/thunar-shares-plugin
            make clean
            ./autogen.sh --prefix=/usr
            make
            sudo make install
            # info on setting up samba: http://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin
        )

        ###################################################################################
        ###################################################################################
        # XFCE_APPS
        ###################################################################################
        ###################################################################################

        echo $xXFCE_APPS | grep gigolo && 
        (
            echo
            echo
            echo "================================================================"
            echo gigolo
            echo "================================================================"
            cd $SOURCE_DIR/gigolo
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep mousepad && 
        (
            echo
            echo
            echo "================================================================"
            echo mousepad
            echo "================================================================"
            #sudo pacman -S gtksourceview4 gspell
            cd $SOURCE_DIR/mousepad
            make clean
            ./autogen.sh    --prefix=/usr \
                            --disable-debug \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug \ 
                            --enable-polkit
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep parole && 
        (
            echo
            echo
            echo "================================================================"
            echo parole
            echo "================================================================"
            #sudo pacman -S taglib gstreamer gst-libav 
            # clutter clutter-gtk clutter-gst cogl (blacklisted - not working properly)
            cd $SOURCE_DIR/parole
            rm -rf m4
            make clean
            ./autogen.sh    --prefix=/usr \
                            --disable-debug \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug \
                            --enable-gtk-doc 
                            # --enable-clutter 
                            #(https://bugzilla.xfce.org/show_bug.cgi?id=11825)
                            #clutter blacklisted 26FEB2017
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep ristretto && 
        (
            echo
            echo
            echo "================================================================"
            echo ristretto
            echo "================================================================"
            cd $SOURCE_DIR/ristretto
            make clean
            ./autogen.sh    --prefix=/usr \
                            --disable-debug \
                            --sysconfdir=/etc \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep xfburn && 
        (
            echo
            echo
            echo "================================================================"
            echo xfburn
            echo "================================================================"
            #sudo pacman -S libburn libisofs
            cd $SOURCE_DIR/xfburn
            make clean
            ./autogen.sh    --prefix=/usr \
                            --disable-debug \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug \
                            --enable-gstreamer
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep xfce4-mixer && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-mixer
            echo "================================================================"
            #sudo pacman -S libkeybinder2
            cd $SOURCE_DIR/xfce4-mixer
            make clean
            ./autogen.sh    --prefix=/usr \
                            --disable-debug \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep xfce4-notifyd && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-notifyd
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-notifyd
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static 
                            --enable-sounds \
                            --disable-debug 
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep xfce4-screenshooter && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-screenshooter
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-screenshooter
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep xfce4-terminal && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-terminal
            echo "================================================================"
            #sudo pacman -S vte3
            cd $SOURCE_DIR/xfce4-terminal
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug 
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep "xfce4-volumed " && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-volumed
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-volumed
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep xfce4-volumed-pulse && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-volumed-pulse
            echo "================================================================"
            #sudo pacman -S libkeybinder3
            cd $SOURCE_DIR/xfce4-volumed-pulse
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep squeeze && 
        (
            echo
            echo
            echo "================================================================"
            echo squeeze
            echo "================================================================"
            cd $SOURCE_DIR/squeeze
            #need to "mkdir m4"
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep orage && 
        (
            echo
            echo
            echo "================================================================"
            echo orage
            echo "================================================================"
            #sudo pacman -S libical
            #needs patch to build against libical3 - https://bugzilla.xfce.org/show_bug.cgi?id=13997
            cd $SOURCE_DIR/orage
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep xfce4-taskmanager && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-taskmanager
            echo "================================================================"
				# optional libgksu
            cd $SOURCE_DIR/xfce4-taskmanager
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep xfce4-dict && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-dict
            echo "================================================================"
            cd $SOURCE_DIR/xfce4-dict
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --disable-static \
                            --disable-debug
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep xfdashboard &&
        (
            echo
            echo
            echo "================================================================"
            echo xfdashboard
            echo "================================================================"
            #sudo pacman -S clutter cogl gio gio-unix dbus-glib libwnck3
            cd $SOURCE_DIR/xfdashboard
            make clean
           ./autogen.sh --prefix=/usr  --sysconfdir=/etc --disable-dependency-tracking
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep xfmpc &&
        (
            echo
            echo
            echo "================================================================"
            echo xfmpc
            echo "================================================================"
            #sudo pacman -S libmpd
            cd $SOURCE_DIR/xfmpc
            make clean
           ./autogen.sh --prefix=/usr  --sysconfdir=/etc 
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep catfish &&
        (
            echo
            echo
            echo "==============================================================="
            echo catfish
            echo "================================================================"
            # pacman -S python-distutils-extra python-dbus python-pexpect
            cd $SOURCE_DIR/catfish
            #rm -f po/catfish.pot
            python setup.py build
            sudo python setup.py install --optimize=1
            sudo install -d "/usr/share/pixmaps"
            sudo ln -sf "/usr/share/icons/hicolor/scalable/apps/catfish.svg" "/usr/share/pixmaps/catfish.svg"
        )    
        cd $SOURCE_DIR
        
        echo $xXFCE_APPS | grep xfce4-panel-profiles &&
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-panel-profiles
            echo "================================================================"
       		# python-gobject 
            cd $SOURCE_DIR/xfce4-panel-profiles

            ./configure --prefix=/usr --python=python
            make 
            sudo make install
         )

        cd $SOURCE_DIR

        echo $xXFCE_APPS | grep xfce4-screensaver &&
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-screensaver
            echo "================================================================"
       		#pacman -S xmlto docbook-xsl libxss dbus-glib
            cd $SOURCE_DIR/xfce4-screensaver

			./autogen.sh \
			  		--prefix=/usr \
					--sysconfdir=/etc \
					--libexecdir="/usr/lib/xfce4-screensaver" \
					--enable-docbook-docs \
					--disable-dependency-tracking
            make 
            sudo make install
         )
        
        cd $SOURCE_DIR

        ###################################################################################
        ###################################################################################
        # XFCE ART
        ###################################################################################
        ###################################################################################

         
        echo $xXFCE_ART | grep xfwm4-themes && 
        (
            echo
            echo
            echo "================================================================"
            echo xfwm4-themes
            echo "================================================================"
            cd $SOURCE_DIR/xfwm4-themes
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --localstatedir=/var
            make
            sudo make install
        )

        cd $SOURCE_DIR        
              
        ###################################################################################
        ###################################################################################
        # Finish up
        ###################################################################################
        ###################################################################################

        echo
        echo
        echo "================================================================"
        echo "================================================================"
        echo "Summary of Components Built:"
        echo "================================================================"
        echo "================================================================"
        echo ""
        echo "XFCE_CORE     = $(echo $xXFCE_CORE | sed -e 's/ /\n\t\t/g')"
        echo "XFCE_ARCHIVE  = $(echo $xXFCE_ARCHIVE | sed -e 's/ /\n\t\t/g')"
        echo "XFCE_BINDINGS = $(echo $xXFCE_BINDINGS | sed -e 's/ /\n\t\t/g')"
        echo "XFCE_PLUGINS  = $(echo $xXFCE_PLUGINS | sed -e 's/ /\n\t\t/g')"
        echo "THUNAR_PLUGINS= $(echo $xTHUNAR_PLUGINS | sed -e 's/ /\n\t\t/g')"
        echo "XFCE_APPS     = $(echo $xXFCE_APPS | sed -e 's/ /\n\t\t/g')"
        echo "XFCE_ART      = $(echo $xXFCE_ART | sed -e 's/ /\n\t/g')"
        echo "================================================================"
        echo "================================================================"
        echo "Done. Log out and back in again."
        echo "================================================================"
        echo "================================================================"
        ;;
    *)
        echo "ToZ's Xfce from git script"
        echo "Built on base arch install"
        echo "Tested only on Arch Linux!!!"
        echo
        echo "Usage: $0 <action>"
        echo "   init -> initialize the build environment MUST BE RUN FIRST!!!"
        echo "   update -> to update the build from the git tree for packages with changes"
        echo "   update-all -> to update all packages regardless of whether there are changes"
        echo
        ;;

esac

exit 0
