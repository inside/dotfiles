# I use gnome-terminal
# the font is monospace 12
# the background color is #002B36
# the red color should be tomato: #ff6347

# Enables colors
autoload -U colors
colors

# vi mode
bindkey -v

# maps jk to escape, same as in my .vimrc
bindkey -M viins 'jk' vi-cmd-mode

# maps insert mode ctrl-j and ctrl-k to move in the history list
bindkey -M viins '^j' vi-down-line-or-history
bindkey -M viins '^k' vi-up-line-or-history

# Allow command line editing in an external editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line # v to edit in an external editor.

# Disables ctrl-s/ctrl-q stop/enable shell flow
stty stop undef

# This way git commands are even shorter
# command_not_found_handler () {
    # git $* || return 127
# }

alias s="git status"
alias d="git diff"
alias p="git push origin HEAD"

# Connects to a virtual machine
vmxpie() {
    if [ -z "$1" ]
    then
        echo "Usage : $(basename $0) 6|7|8|9 [host number]"
        return
    fi

    host="vmie$1"
    echo "connecting to $host"
    rdesktop -u 'y.thomas-gerard' -d 'DAILY' -f -a 16 -k fr -z -xb -P "$host"
}

# Will return the current branch name
# Usage example: git pull origin $(current_branch)
function current_branch() {
  ref=$(git rev-parse --abbrev-ref HEAD 2> /dev/null) \
      || return
  echo $ref
}

alias ra="sudo /etc/init.d/apache2 restart"
alias ls="ls -G --color"
alias ll="ls -G -l --color"
alias fgrep="fgrep --color=always --exclude='*.git*'"
alias lynx="lynx -accept_all_cookies"
alias flashlog="tail -f ~/.macromedia/Flash_Player/Logs/flashlog.txt"
alias v=vim
alias git=hub
alias g=git
alias m=npm
alias mr=npm\ run
alias mux=tmuxinator
compdef hub=git
alias sudo="sudo "

setopt ALWAYS_TO_END                     # Saute apres le mot si completion
setopt AUTO_CD                           # CD facultatif
setopt AUTO_LIST                         # Liste de completion automatique
setopt AUTO_MENU                         # Menu de completion automatique
setopt AUTO_PARAM_KEYS                   # Completion parametres facultative
unsetopt COMPLETE_ALIASES                # Pas de substitution avec completion
setopt COMPLETE_IN_WORD                  # Deplace le curseur apres completion
setopt MARK_DIRS                         # Ajoute un / apres les repertoires
setopt NO_BEEP                           # Silence
setopt NO_HIST_BEEP                      # Silence (2)
setopt NO_LIST_BEEP                      # Silence (3)
setopt NUMERIC_GLOBSORT                  # Tri numerique sur completions
setopt PROMPT_SUBST                      # Prompts etendus
unsetopt EXTENDED_HISTORY                # Historique avec timings = bof
setopt HIST_NO_STORE                     # N'enregistre pas la cmd history
setopt noflowcontrol                     # restores the use of the keys ctrl-s, ctrl-q
setopt HIST_SAVE_NO_DUPS
setopt SHARE_HISTORY

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history

# Variables
PROMPT=$(echo '\
%{$fg_bold[green]%}%n@%m\
%{$fg_no_bold[green]%}:%~ \
%{$fg_bold[red]%}$(current_branch)\
%{$fg_no_bold[cyan]%} %D{%b %e %T} \
P%j\n%{$reset_color%}\
%# ')

# export NODE_PATH=/usr/lib/node_modules
export CDPATH=.:~/github:~/.vim/bundle:~/src
export LC_ALL=en_US.UTF8
export PAGER=$(which less)
export EDITOR=vim

# Prevent duplicates to be added to $PATH
typeset -aU path
path=( $path ~/bin )

export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data
# Set TERM to xterm-256color in your .bashrc, and put term screen-256color in
# your .screenrc
export TERM=xterm-256color

zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# Predictable SSH authentication socket location.
# http://qq.is/tutorial/2011/11/17/ssh-keys-through-screen.html
SOCK="/tmp/ssh-agent-$USER-screen"
if test $SSH_AUTH_SOCK && [ $SSH_AUTH_SOCK != $SOCK ]
then
    rm -f /tmp/ssh-agent-$USER-screen
    ln -sf $SSH_AUTH_SOCK $SOCK
    export SSH_AUTH_SOCK=$SOCK
fi

# Autoload tmux if we aren't in it
# Put this as last command
if [[ $TMUX = '' ]] && [[ $SSH_CLIENT != '' ]] then
    tmux attach
fi

[ -f ~/.local.zsh ] && source ~/.local.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
