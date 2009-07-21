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

# Change directory when only path typed
setopt auto_cd

# d -[Tab] --> list history 
setopt auto_pushd

# Correct command
setopt correct

# Display packed list
setopt list_packed 

# Beep off
setopt nolistbeep

# Alias
alias la='ls -AFlh'
alias ll='ls -Flh'
alias l=ls
alias df='df -h'
alias p=pushd pp=popd
alias j=jobs

# Oracle
alias ob='cd $ORACLE_BASE'
alias oi='cd $ORACLE_BASE/oraInventory'
alias oh='cd $ORACLE_HOME'
alias od='cd $ORACLE_BASE/oradata/orcl'
export LANG=C
export NLS_LANG=American_America.JA16EUC
