#!/bin/bash
#
# "borrowed" from Jonathan Palardy (http://github.com/jpalardy/etc_config/tree/master)
 
function relink()
{
  rm $1
  ln -s $2 $1
}
 
cd
 
relink .vim github/dotfiles/.vim
relink .vimrc github/dotfiles/.vimrc
