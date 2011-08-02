#!/bin/sh

cd ~/.oh-my-zsh && \
git remote update && \
git co inside && \
git pull upstream master && \
git push origin inside && \
git pull origin inside && \
cd ~/github/dotfiles && \
git ci -a -m sync && \
git push origin master
