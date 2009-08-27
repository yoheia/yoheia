# LANG
export LANG=C

# see manual umask
umask 022
	
# core dump size
limit coredumpsize 0

# Autocomplete
autoload -U compinit
compinit

# Prompt
case ${UID} in
0)
    PROMPT="%{[31m%}%n%%%{[m%} "
    RPROMPT="[%~]"
    PROMPT2="%B%{[31m%}%_#%{[m%}%b "
    SPROMPT="%B%{[31m%}%r is correct? [n,y,a,e]:%{[m%}%b "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
    ;;
*)
    PROMPT="%{[31m%}%n%%%{[m%} "
    RPROMPT="[%~]"
    PROMPT2="%{[31m%}%_%%%{[m%} "
    SPROMPT="%{[31m%}%r is correct? [n,y,a,e]:%{[m%} "
    [ -n "${REMOTEHOST}${SSH_CONNECTION}" ] && 
        PROMPT="%{[37m%}${HOST%%.*} ${PROMPT}"
    ;;
esac

# History
HISTFILE=~/.zsh_history
HISTSIZE=6000000
SAVEHIST=6000000
setopt hist_ignore_dups     # ignore duplication command history list
setopt share_history        # share command history data

# History search
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

# see manual zshoptions(1)
setopt AUTO_CD     # Change directory when only path typed
setopt AUTO_PUSHD  # d -[Tab] --> list history 
setopt CORRECT     # Correct command
setopt LIST_PACKED # Display packed list
setopt NOLISTBEEP  # Beep off
setopt SHORTLOOPS

# Alias
alias la='ls -AFlh'
alias ll='ls -Flh'
alias l=ls
alias df='df -h'
alias p=pushd pp=popd
alias j=jobs
alias h=history
alias x=exit
alias df='df -h'
alias du='du -h'
alias tf='tail -f'
alias c='clear'
alias mv='nocorrect mv'
alias cp='nocorrect cp'
alias rm='rm -i'
alias ps='ps -ef'

export PAGER=less
export OSTYPE=`uname -s`

# load platform configuration
case $OSTYPE in
    Linux*)
	[ -r $HOME/.zshrc.linux ] && source $HOME/.zshrc.linux
	;;
    FreeBSD*)
	[ -r $HOME/.zshrc.freebsd ] && source $HOME/.zshrc.freebsd
	;;
    Darwin*)
	[ -r $HOME/.zshrc.darwin ] && source $HOME/.zshrc.darwin
	;;
    SunOS*)
	[ -r $HOME/.zshrc.solaris ] && source $HOME/.zshrc.solaris
	;;
esac

# load local configuration
[ -r $HOME/.zshrc.local ] && source $HOME/.zshrc.local
