#!/bin/bash
#
# "borrowed" from Jonathan Palardy (http://github.com/jpalardy/etc_config/tree/master)

DOTFILES_DIR=~/github/dotfiles/

function relink() {
    rm "$2"
    ln -s "$1" "$2"
}

cd

for I in $(ls -a $DOTFILES_DIR)
do
    if [[ \
        $I == '.' || \
        $I == '..' || \
        $I == '.git' || \
        $I == '.gitignore' || \
        $I == $(basename "$0") ]]
    then
        continue
    fi

    relink "$DOTFILES_DIR$I" ~/$I
done
