#!/bin/bash
# for Arch: XFCE GIT BUILD/UPDATE SCRIPT
# Requires: git wget
# Optional: screen
###################################################################################
# use "screen -L" to create a log file of the install/update
###################################################################################
#
# Last updated: November 24, 2024

LOG="$HOME/Development/$(date +%s).xfcegit.log"

###################################################################################
# directory to hold source files 
SOURCE_DIR=~/Development/Xfce.git
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
                libxfce4windowing.git
                xfce4-panel.git
                thunar.git
                xfce4-settings.git
                xfce4-session.git
                xfwm4.git
                xfdesktop.git
                xfce4-appfinder.git
                tumbler.git
                thunar-volman.git
                xfce4-power-manager.git"                            
#   gtk-xfce-engine has disappeared                

# list of Xfce plugins
XFCE_PLUGINS="  xfce4-clipman-plugin.git
                xfce4-cpufreq-plugin.git
                xfce4-docklike-plugin.git
                xfce4-eyes-plugin.git
                xfce4-genmon-plugin.git
                xfce4-mailwatch-plugin.git
                xfce4-mpc-plugin.git
                xfce4-netload-plugin.git
                xfce4-notes-plugin.git
                xfce4-places-plugin.git
                xfce4-pulseaudio-plugin.git
                xfce4-sensors-plugin.git
                xfce4-systemload-plugin.git
                xfce4-timer-plugin.git
                xfce4-weather-plugin.git
                xfce4-whiskermenu-plugin.git
                xfce4-xkb-plugin.git"

# list of thunar plugins
THUNAR_PLUGINS="thunar-archive-plugin.git
                thunar-media-tags-plugin.git
                thunar-shares-plugin.git"

# list of Xfce apps
XFCE_APPS="     catfish.git
                gigolo.git
                mousepad.git
                parole.git
                ristretto.git
                xfburn.git
                xfce4-dict.git
                xfce4-notifyd.git
                xfce4-panel-profiles.git
                xfce4-screenshooter.git
                xfce4-screensaver.git
                xfce4-terminal.git
                xfce4-taskmanager.git
                xfce4-volumed-pulse.git
                xfdashboard.git
                xfmpc.git"

# DO NOT EDIT - listing of packages to build (with pending git changes)
xXFCE_CORE=""
xXFCE_PLUGINS=""
xTHUNAR_PLUGINS=""
xXFCE_APPS=""

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
        
        # Build dependencies
        sudo pacman -S \
            base-devel xorg xorg-xinit pipewire \
            libxslt meson docbook-xsl \
            gtk-doc gobject-introspection \
            glib2-devel vala \
            gtk3 startup-notification libgtop libgudev \
            libwnck3 libdisplay-info wayland wlr-protocols \
            gtk-layer-shell libdbusmenu-gtk3 \
            libnotify \
            libxklavier libcanberra xf86-input-libinput \
            polkit xorg-iceauth \
            libxpresent \
            libyaml \
            gdk-pixbuf2 ffmpegthumbnailer freetype2 libgsf libopenraw poppler-glib libgepub \
            upower \
            qrencode \
            libmpd \
            gtksourceview4 \
            libkeybinder3 pavucontrol \
            cmake accountsservice \
            taglib \
            python-gobject python-dbus python-pexpect \
            gspell \
            dbus-glib \
            libexif \
            libburn libisofs \
            libxrandr libxss \
            vte3 \
            libxmu \
            clutter 

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
        ###################################################################################

        ###################################################################################
        # if update-all specified, make it so all packages get updated
        if [ "$1" == "update-all" ];
        then
            xXFCE_CORE="$XFCE_CORE "
            xXFCE_PLUGINS=$XFCE_PLUGINS 
            xTHUNAR_PLUGINS=$THUNAR_PLUGINS
            xXFCE_APPS=$XFCE_APPS
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
            ### libsxlt meson docbook-xsl
            cd $SOURCE_DIR/xfce4-dev-tools
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ### gtk-doc gobject-introspection
            cd $SOURCE_DIR/libxfce4util
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --enable-introspection
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
            ### glib2-devel vala
            cd $SOURCE_DIR/xfconf
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ### gtk3 startup-notification libgtop libgudev
            cd $SOURCE_DIR/libxfce4ui
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ### 
            cd $SOURCE_DIR/garcon
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ### 
            cd $SOURCE_DIR/exo
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ### libwnck3 libdisplay-info wayland wlr-protocols
            cd $SOURCE_DIR/libxfce4windowing
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ### gtk-layer-shell libdbusmenu-gtk3
            cd $SOURCE_DIR/xfce4-panel
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ### libnotify
            cd $SOURCE_DIR/thunar
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ### libxklavier libcanberra xf86-input-libinput
            #** not enabling upower support
            cd $SOURCE_DIR/xfce4-settings
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
                            --enable-sound-settings
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
            ### polkit xorg-iceauth
            cd $SOURCE_DIR/xfce4-session
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ### libxpresent
            cd $SOURCE_DIR/xfwm4
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib ]
                            --enable-xi2
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
            ### libyaml
            cd $SOURCE_DIR/xfdesktop
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib \
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
            ###
            cd $SOURCE_DIR/xfce4-appfinder
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ### gdk-pixbuf2 ffmpegthumbnailer freetype2 libgsf libopenraw poppler-glib libgepub
            cd $SOURCE_DIR/tumbler
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ###
            cd $SOURCE_DIR/thunar-volman
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ### upower
            cd $SOURCE_DIR/xfce4-power-manager
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
            make
            sudo make install
        )

        ###################################################################################
        ###################################################################################
        # XFCE_PLUGINS
        ###################################################################################
        ###################################################################################

        echo $xXFCE_PLUGINS | grep xfce4-clipman-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-clipman-plugin
            echo "================================================================"
            ### qrencode
            cd $SOURCE_DIR/xfce4-clipman-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ###
            cd $SOURCE_DIR/xfce4-cpufreq-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-docklike-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-docklike-plugin
            echo "================================================================"
            ### 
            cd $SOURCE_DIR/xfce4-docklike-plugin
            make clean   
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib   
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
            ###
            cd $SOURCE_DIR/xfce4-eyes-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ###
            cd $SOURCE_DIR/xfce4-genmon-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-mailwatch-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-mailwatch-plugin
            echo "================================================================"
            ###
            cd $SOURCE_DIR/xfce4-mailwatch-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-mpc-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-mpc-plugin
            echo "================================================================"
            ### libmpd
            cd $SOURCE_DIR/xfce4-mpc-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ###
            cd $SOURCE_DIR/xfce4-netload-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
            make
            sudo make install
        )
        
        echo $xXFCE_PLUGINS | grep xfce4-notes-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-notes-plugin
            echo "================================================================"
            ### gtksourceview4
            cd $SOURCE_DIR/xfce4-notes-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ###
            cd $SOURCE_DIR/xfce4-places-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
            make
            sudo make install
        )
        
        echo $xXFCE_PLUGINS | grep xfce4-pulseaudio-plugin && 
        (
            echo
            echo "================================================================"
            echo xfce4-pulseaudio-plugin
            echo "================================================================"
            ### libkeybinder3 pavucontrol
            # 03MAR15 - added --with-mixer-command parameter
            cd $SOURCE_DIR/xfce4-pulseaudio-plugin
            make clean   
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ### 
            cd $SOURCE_DIR/xfce4-sensors-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ###
            cd $SOURCE_DIR/xfce4-systemload-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ###
            cd $SOURCE_DIR/xfce4-timer-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
            make
            sudo make install
        )

        echo $xXFCE_PLUGINS | grep xfce4-weather-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-weather-plugin
            echo "================================================================"
            ### 
            cd $SOURCE_DIR/xfce4-weather-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ### cmake accountsservice
            cd $SOURCE_DIR/xfce4-whiskermenu-plugin
            make clean
            cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr  -DCMAKE_INSTALL_LIBDIR=/usr/lib -GNinja
            cmake --build build
            sudo cmake --install build
        )        
        
        echo $xXFCE_PLUGINS | grep xfce4-xkb-plugin && 
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-xkb-plugin
            echo "================================================================"
            ###
            cd $SOURCE_DIR/xfce4-xkb-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ###
            cd $SOURCE_DIR/thunar-archive-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ### taglib
            cd $SOURCE_DIR/thunar-media-tags-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib
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
            ###
            cd $SOURCE_DIR/thunar-shares-plugin
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
            make
            sudo make install
            # info on setting up samba: http://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin
        )

        ###################################################################################
        ###################################################################################
        # XFCE_APPS
        ###################################################################################
        ###################################################################################

        echo $xXFCE_APPS | grep catfish &&
        (
            echo
            echo
            echo "==============================================================="
            echo catfish
            echo "================================================================"
            ### python-gobject python-dbus python-pexpect
            cd $SOURCE_DIR/catfish
            meson setup build
    	    meson compile -C build
    	    sudo meson install -C build
        )  

        echo $xXFCE_APPS | grep gigolo && 
        (
            echo
            echo
            echo "================================================================"
            echo gigolo
            echo "================================================================"
            ###
            cd $SOURCE_DIR/gigolo
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ### gspell
            cd $SOURCE_DIR/mousepad
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ### dbus-glib
            cd $SOURCE_DIR/parole
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ### libexif
            cd $SOURCE_DIR/ristretto
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ### libburn libisofs
            cd $SOURCE_DIR/xfburn
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ### 
            cd $SOURCE_DIR/xfce4-dict
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ###
            cd $SOURCE_DIR/xfce4-notifyd
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep xfce4-panel-profiles &&
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-panel-profiles
            echo "================================================================"
       		#### 
            cd $SOURCE_DIR/xfce4-panel-profiles
            ./configure --prefix=/usr 
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
            ###
            cd $SOURCE_DIR/xfce4-screenshooter
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
            make
            sudo make install
        )

        echo $xXFCE_APPS | grep xfce4-screensaver &&
        (
            echo
            echo
            echo "================================================================"
            echo xfce4-screensaver
            echo "================================================================"
       		### libxrandr libxss
            cd $SOURCE_DIR/xfce4-screensaver
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ### vte3
            cd $SOURCE_DIR/xfce4-terminal
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
			### libxmu
            cd $SOURCE_DIR/xfce4-taskmanager
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ### 
            cd $SOURCE_DIR/xfce4-volumed-pulse
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc 
			    --libexecdir=/usr/lib
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
            ### clutter
            cd $SOURCE_DIR/xfdashboard
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
            ###
            cd $SOURCE_DIR/xfmpc
            make clean
            ./autogen.sh    --prefix=/usr \
                            --sysconfdir=/etc \
                            --libexecdir=/usr/lib 
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
        echo "XFCE_PLUGINS  = $(echo $xXFCE_PLUGINS | sed -e 's/ /\n\t\t/g')"
        echo "THUNAR_PLUGINS= $(echo $xTHUNAR_PLUGINS | sed -e 's/ /\n\t\t/g')"
        echo "XFCE_APPS     = $(echo $xXFCE_APPS | sed -e 's/ /\n\t\t/g')"
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
