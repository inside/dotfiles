# Reads ouput of command in vim (Usage: $ vv ps ax)
vv ()
{
    $@ | vim -R -
}

# get the name of the branch we are on
git_prompt_info()
{
    ref=$(git symbolic-ref HEAD 2> /dev/null) || return
    echo "(${ref#refs/heads/})"
}

# Connects to a virtual machine
vmxpie()
{
    if [ -z "$1" ]
    then
        echo "Usage : $(basename $0) 6|7|8 [host number]"
        return
    fi

    host="vmxpie$1-01"

    if [ -n "$2" ]
    then
        host="vmxpie$1-$2"
    fi

    echo "connecting to $host"
    rdesktop -u 'y.thomas-gerard' -d 'DAILY' -f -a 16 -k fr -z -xb -P "$host"
}

HISTFILE="$HOME/.zshistory"              # Fichier d'historique
HISTSIZE=1000                            # Taille de l'historique
LISTMAX=0                                # Limite d'affichage pour completion
LISTHISTSIZE=1000                        # Historique litteral
SAVEHIST=1000                            # Historique a sauver

#bindkey -v
#bindkey -em
bindkey -e

# (C) Jedi/Sector One (j@nether.net)

zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=2
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
#style ':completion:*:sudo:*' command-path /home/inside/bin /usr/local/sbin /usr/local/bin \
                 #/usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

autoload -U compinit colors
compinit
colors

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

# aliases
alias ra="sudo /etc/init.d/apache2 restart"
alias vi="vim"
alias ls="ls --color=auto --classify"
alias ll="ls --color=auto -l --classify"
alias unison="unison -ui text"
alias dev="ssh inside@mydev"
alias mdev="mount /mnt/dev"
alias umdev="umount /mnt/dev"
alias fgrep="fgrep --color=always --exclude='*.git*'"
alias lynx="lynx -accept_all_cookies"
alias devmysql="mysql -h devdb -u dev -p"
alias logprod="ssh dev@logprod"
alias gs="git status"
alias gd="git diff"
alias gc="git checkout"
alias gl="git log"
alias gp="git pull --rebase"
alias gf="git fetch"
alias ggrep="git grep"
alias ack="ack-grep"
alias devlog="ssh inside@mydev 'sudo bin/showlog.sh'"
alias llog="sudo tail -f /var/log/apache2/dailymotion-error.log"

# variables
export PAGER=$(which less)
export EDITOR=$(which vim)
export PATH=$PATH:~/bin:~/sdk/flex/bin
export APACHE_RUN_USER=www-data
export APACHE_RUN_GROUP=www-data

# commands
[ -f ~/.profile ] && source ~/.profile
umask 002
stty stop undef

PROMPT=$'%{$fg_bold[green]%}%n@%m:%~ %{$fg_bold[red]%}$(git_prompt_info)%{$fg[blue]%} %D{%a %b %e %T} P%j% \n%{$reset_color%}$ '

# MySql client prompt
export MYSQL_PS1="(\u@\h) [\d]> "
