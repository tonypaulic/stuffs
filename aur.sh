#!/bin/bash

### globals
URL="https://aur.archlinux.org/cgit/aur.git/snapshot/"
EXT=".tar.gz"
DIR="$HOME/.cache/AUR"

### create or empty dir on start
[[ -d "$DIR" ]] && rm -rf "$DIR"/* || mkdir -p $DIR
cd "$DIR"

### in Palpatine's voice, do the building using makepkg
do_it () {
for file in $1
do
 wget "$URL$file$EXT"
 tar xzvf "$file$EXT"
 cd "$file"
 makepkg -si --noconfirm
 cd ..
 rm "$file$EXT"
 rm -rf "$file"
done
}

if [ $# -gt 0 ]; then
for i in "$@"; do
 do_it "$i"
done
fi
