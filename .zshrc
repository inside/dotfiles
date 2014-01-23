# Enables colors
autoload -U colors
colors

# vi mode
bindkey -v

# maps jk to escape, same as in my .vimrc
bindkey -M viins 'jk' vi-cmd-mode

# Disables ctrl-s/ctrl-q stop/enable shell flow
stty stop undef

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
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo ${ref#refs/heads/}
}

alias devdm="ssh-add; ssh -A inside@inside"
alias devcloud="ssh-add; ssh -A ytg@devcloud"
alias devmysql="mysql -h devdb -u dev -p"
alias stage="ssh-add; ssh -A dev@prov"
alias logprod="ssh dev@syslog-02"
alias log="sudo tail -f /var/log/apache2/dailymotion-error.log"
alias ra="sudo /etc/init.d/apache2 restart"
alias ls="ls -G --color"
alias ll="ls -G -l --color"
alias fgrep="fgrep --color=always --exclude='*.git*'"
alias lynx="lynx -accept_all_cookies"
alias flashlog="tail -f ~/.macromedia/Flash_Player/Logs/flashlog.txt"
alias gs="git status"
alias gd="git diff"
alias gc="git checkout"
alias gl="git log"
alias gp="git pull --rebase"
alias gf="git fetch"
alias ggrep="git grep"
alias ge="git-edit"
alias gpush="git push origin $(current_branch)"
alias vi=~/bin/vim
alias bower='noglob bower'

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

# Variables
PROMPT=$(echo '\
%{$fg_bold[green]%}%n@%m\
%{$fg_no_bold[green]%}:%~ \
%{$fg_bold[red]%}$(current_branch)\
%{$fg_no_bold[cyan]%} %D{%b %e %T} \
P%j\n%{$reset_color%}\
%# ')

export LC_ALL=en_US.UTF8
export PAGER=$(which less)
export EDITOR=$(which vim)
export PATH=$PATH:~/bin:~/bin/git:~/scripts:~/scripts/git
export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data
# Set TERM to xterm-256color in your .bashrc, and put term screen-256color in
# your .screenrc
export TERM=xterm-256color

# http://vim.wikia.com/wiki/Configuring_the_cursor
echo -ne "\033]12;#ffffff\007"

zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s

# Autoload screen if we aren't in it
if [[ $STY = '' ]] && [[ $SSH_CLIENT != '' ]] then
    screen -xR
fi
