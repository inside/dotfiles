#!/bin/bash
#
# "borrowed" from Jonathan Palardy (http://github.com/jpalardy/etc_config/tree/master)
 
DOTFILES_DIR=~/github/dotfiles/

function relink()
{
    rm $1
    ln -s $2 $1
}
 
cd
 
for I in $(ls -a $DOTFILES_DIR)
do
    if [[ \
        $I == '.' || \
        $I == '..' || \
        $I == '.git' || \
        $I == '.gitignore' || \
        $I == $(basename $0) ]]
    then
        continue
    fi

    relink $I "$DOTFILES_DIR$I"
done
