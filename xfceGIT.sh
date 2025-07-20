#!/bin/bash
# for Arch: XFCE GIT BUILD/UPDATE SCRIPT
# Requires: git wget meson
# Optional: screen
###################################################################################
# use "screen -L" to create a log file of the install/update
###################################################################################
#
# Last updated: July 16, 2025 (migration to meson)

LOG="$HOME/Development/$(date +%s).xfcegit.log"
PREFIX="/usr"			# default is /usr/local

####################################################################################
# list of Xfce core components to build
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

###################################################################################
# directory to hold source files 
SOURCE_DIR=~/Development/Xfce.git
mkdir -p $SOURCE_DIR
cd $SOURCE_DIR
###################################################################################

####################################################################################
# support functions

build () {
	# function to build package via meson
	# $1 = package
	# $2 = extra options
    echo
    echo
    echo "================================================================"
    echo $1
    echo "================================================================"
	cd $SOURCE_DIR/$1	
	meson setup --reconfigure build --prefix=$PREFIX $2
	meson compile -C build
	sudo meson install -C build
}

version () {
	# function to return version numbers of components
	# $1 is component name
	D=$(echo $1 | sed 's/.git//')

	case $D in
		xfce4-dev-tools|exo|xfdashboard)
			cat $SOURCE_DIR/$D/configure.ac | grep XDT_VERSION | awk -F '[' '{print " "$2"-"$3}' | tr -d '],) '
		;;
		*)
			[[ -f $SOURCE_DIR/$D/meson.build ]] && cat $SOURCE_DIR/$D/meson.build | grep version | sed 's/license//' | awk -F':' '{print $2}' | tr -d "'," | head -1
		;;
	esac
}
	

##################################################################################

case $1 in

    info)
		echo "================================================================"
        echo "Current Xfce Component Versions:"
		echo "================================================================"
		echo "Xfce Core"
		for x in $XFCE_CORE
		do
			v=$(version $x)	
			echo "  $x = $v" | sed -e 's/.git//'
		done

		echo "Panel Plugins"
		for x in $XFCE_PLUGINS
		do
			v=$(version $x)			
			echo "  $x = $v" | sed -e 's/.git//'
		done

		echo "Thunar Plugins"
		for x in $THUNAR_PLUGINS
		do
			v=$(version $x)			
			echo "  $x = $v" | sed -e 's/.git//'
		done

		echo "Xfce Apps"
		for x in $XFCE_APPS
		do
			v=$(version $x)			
			echo "  $x = $v" | sed -e 's/.git//'
		done
		;;
	
	log)
        [[ $2 -gt 0 ]] && NUM=$2 || NUM=10

		if [ -n $3 ]; then
			cd $SOURCE_DIR/$3 || exit 1
	        echo "========== $3 =========="
	        git log --graph --pretty=format:"%h%x09%ad  %s" --date=short | grep -v I18n | head -$NUM 
	        echo ""
	        cd ..
			exit 0
		fi

        for d in *; do 
            cd $d
            echo "========== $d =========="
            git log --graph --pretty=format:"%h%x09%ad  %s" --date=short | grep -v I18n | head -$NUM 
            echo ""
            cd ..
        done |& less -F
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
            gtk3 startup-notification libgtop libgudev glade \
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
			zeitgeist \
            python-gobject python-dbus python-pexpect \
            gspell \
            dbus-glib \
            libexif \
            libburn libisofs \
			python-psutil \
			help2man \
            libxrandr libxss xmlto \
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
		
			### libxfce4util = gtk-doc gobject-introspection
        echo $xXFCE_CORE | grep libxfce4util && build libxfce4util
			### xfconf = glib2-devel vala
        echo $xXFCE_CORE | grep xfconf && build xfconf
        	### libxfce4ui = gtk3 startup-notification libgtop libgudev glade
        echo $xXFCE_CORE | grep libxfce4ui && build libxfce4ui
			### garcon = 
        echo $xXFCE_CORE | grep garcon && build garcon
			###
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
            make
            sudo make install
        )

			### libxfce4windowing = libwnck3 libdisplay-info wayland wlr-protocols
        echo $xXFCE_CORE | grep libxfce4windowing && build libxfce4windowing
			### xfce4-panel = gtk-layer-shell libdbusmenu-gtk3
	    echo $xXFCE_CORE | grep xfce4-panel && build xfce4-panel
			### thunar = libnotify
        echo $xXFCE_CORE | grep -e "thunar.git " -e "thunar.git$" && build thunar
			### xfce4-settings = libxklavier libcanberra xf86-input-libinput
        echo $xXFCE_CORE | grep xfce4-settings && build xfce4-settings
			### xfce4-session = polkit xorg-iceauth
        echo $xXFCE_CORE | grep xfce4-session && build xfce4-session
			### xfwm4 = libxpresent
        echo $xXFCE_CORE | grep xfwm4 && build xfwm4
			### xfdesktop = libyaml
        echo $xXFCE_CORE | grep xfdesktop && build xfdesktop
			###
        echo $xXFCE_CORE | grep xfce4-appfinder && build xfce4-appfinder
			### tumbler = gdk-pixbuf2 ffmpegthumbnailer freetype2 libgsf libopenraw poppler-glib libgepub
        echo $xXFCE_CORE | grep tumbler && build tumbler
			###
        echo $xXFCE_CORE | grep thunar-volman && build thunar-volman
			### xfce4-power-manager = upower
        echo $xXFCE_CORE | grep xfce4-power-manager && build xfce4-power-manager

        ###################################################################################
        ###################################################################################
        # XFCE_PLUGINS
        ###################################################################################
        ###################################################################################

			### xfce4-clipman-plugin = qrencode
        echo $xXFCE_PLUGINS | grep xfce4-clipman-plugin && build xfce4-clipman-plugin 
        	###
        echo $xXFCE_PLUGINS | grep xfce4-cpufreq-plugin && build xfce4-cpufreq-plugin
			###
        echo $xXFCE_PLUGINS | grep xfce4-docklike-plugin && build xfce4-docklike-plugin
			### 
        echo $xXFCE_PLUGINS | grep xfce4-eyes-plugin && build xfce4-eyes-plugin 
			###                
        echo $xXFCE_PLUGINS | grep xfce4-genmon-plugin && build xfce4-genmon-plugin
			###
        echo $xXFCE_PLUGINS | grep xfce4-mailwatch-plugin && build xfce4-mailwatch-plugin
			### xfce4-mpc-plugin = libmpd
        echo $xXFCE_PLUGINS | grep xfce4-mpc-plugin && build xfce4-mpc-plugin 
			###        
        echo $xXFCE_PLUGINS | grep xfce4-netload-plugin && build xfce4-netload-plugin
			### xfce4-notes-plugin = gtksourceview4
        echo $xXFCE_PLUGINS | grep xfce4-notes-plugin && build xfce4-notes-plugin
			###
        echo $xXFCE_PLUGINS | grep xfce4-places-plugin && build xfce4-places-plugin
        	### xfce4-pulseaudio-plugin = libkeybinder3 pavucontrol
        echo $xXFCE_PLUGINS | grep xfce4-pulseaudio-plugin && build xfce4-pulseaudio-plugin
			###                        
        echo $xXFCE_PLUGINS | grep xfce4-sensors-plugin && build xfce4-sensors-plugin
			###
        echo $xXFCE_PLUGINS | grep xfce4-systemload-plugin && build xfce4-systemload-plugin
			###
        echo $xXFCE_PLUGINS | grep xfce4-timer-plugin && build xfce4-timer-plugin
			###
        echo $xXFCE_PLUGINS | grep xfce4-weather-plugin && build xfce4-weather-plugin
			### xfce4-whiskermenu-plugin = cmake accountsservice
        echo $xXFCE_PLUGINS | grep xfce4-whiskermenu-plugin && build xfce4-whiskermenu-plugin
      		###        
        echo $xXFCE_PLUGINS | grep xfce4-xkb-plugin && build xfce4-xkb-plugin

        ###################################################################################
        ###################################################################################
        # THUNAR_PLUGINS
        ###################################################################################
        ###################################################################################

			###
        echo $xTHUNAR_PLUGINS | grep thunar-archive-plugin && build thunar-archive-plugin
			### thunar-media-tags-plugin = taglib
        echo $xTHUNAR_PLUGINS | grep thunar-media-tags-plugin && build thunar-media-tags-plugin
			###
			# info on setting up samba: http://goodies.xfce.org/projects/thunar-plugins/thunar-shares-plugin
        echo $xTHUNAR_PLUGINS | grep thunar-shares-plugin && build thunar-shares-plugin

        ###################################################################################
        ###################################################################################
        # XFCE_APPS
        ###################################################################################
        ###################################################################################

			### catfish = zeitgist
        echo $xXFCE_APPS | grep catfish && build catfish
			###
        echo $xXFCE_APPS | grep gigolo && build gigolo
			### mousepad = gspell
        echo $xXFCE_APPS | grep mousepad && build mousepad
			### parole = dbus-glib
        echo $xXFCE_APPS | grep parole && build parole
			###
        echo $xXFCE_APPS | grep ristretto && build ristretto
			### xfburn = libburn libisofs
        echo $xXFCE_APPS | grep xfburn && build xfburn
			###
        echo $xXFCE_APPS | grep xfce4-dict && build xfce4-dict
			###
        echo $xXFCE_APPS | grep xfce4-notifyd && build xfce4-notifyd
			### xfce4-panel-profiles = python-psutil
        echo $xXFCE_APPS | grep xfce4-panel-profiles && build xfce4-panel-profiles
			### xfce4-screenshooter = help2man        
        echo $xXFCE_APPS | grep xfce4-screenshooter && build xfce4-screenshooter
			### xfce4-screensaver = libxrandr libxss xmlto
        echo $xXFCE_APPS | grep xfce4-screensaver && build xfce4-screensaver
         	### xfce4-terminal = vte3
        echo $xXFCE_APPS | grep xfce4-terminal && build xfce4-terminal
			###
        echo $xXFCE_APPS | grep xfce4-taskmanager && build xfce4-taskmanager
			###
        echo $xXFCE_APPS | grep xfce4-volumed-pulse && build xfce4-volumed-pulse
			### xfdashboard = clutter
        
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

			###
        echo $xXFCE_APPS | grep xfmpc && build xfmpc

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
		echo "   log [LINES] [PACKAGE] -> display non-translation git commits at LINES lines per package"
		echo "   info -> list current package versions"
        echo
        ;;
esac

exit 0

################################### Wayand/wayfire instructions
cd ~/Development
wget https://aur.archlinux.org/cgit/aur.git/snapshot/yay.tar.gz
tar xzvf yay.tar.gz
cd yay
makepkg -si
yay -S wayfire
cd ~/.config
wget https://raw.githubusercontent.com/tonypaulic/stuffs/refs/heads/master/wayfire.ini
cd
startxfce4 --wayland wayfire
################################### 
