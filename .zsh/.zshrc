# Useful commands
# find . -name "*" -exec grep -n hello /dev/null {} \; # {} is find file
# sed -r 's/.* token_start (.+) token_end .*/\1/'
# sed ':a;N;$!ba;s/\n/ /g' merge two lines to check pattern
# <(cmd) <(cmd) For asynchron piping

#export TERM='screen-256color'

# Root allow X?
# xhost + > /dev/null 2> /dev/null || true

# Let's reset caps lock (setxkbmap -option to re-enable)
# setxkbmap -option ctrl:nocaps

###########################################################        
# Options for Zsh

export HISTFILE=~/.zsh_history
export HISTSIZE=50000
export SAVEHIST=50000
eval `dircolors -b`

set -o vi
bindkey -v
#kill the lag
#export KEYTIMEOUT=1

autoload -Uz compinit 
setopt autopushd pushdminus pushdsilent pushdtohome
setopt autocd
setopt cdablevars
#setopt ignoreeof
setopt interactivecomments
#setopt nobanghist
setopt noclobber # Use >! to override file
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE
setopt SH_WORD_SPLIT
setopt nohup
setopt transientrprompt
#setopt PRINT_EXIT_VALUE

#print colors
CREDOR='%{\e[1;31m%}'
CBROWN='%{\e[0;33m%}'
CCYAN='%{\e[1;30m%}'
BOLDNOC='%{\e[1;0m%}'
NOCOLOR='%{\e[0m%}'
MCOLOR='%{\e[0;35m%}'
CBLUE='%{\e[1;34m%}'
CGREEN='%{\e[1;32m%}'

# PS1 and PS2
export PS1="$(print $CBROWN'(%D{%L:%M:%S %p})\n'$CREDOR'['$CBLUE'%n'$CREDOR'@'$CGREEN'%M'$CREDOR']'$MCOLOR%~%b$CCYAN'\n$ ')"
export PS2="$(print '%{\e[0;34m%}>'$NOCOLOR)"

#export RPROMPT='[%D{%L:%M:%S %p}]'
#TMOUT=0
#TRAPALRM() {
#   zle reset-prompt
#}
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git svn
precmd() {
  vcs_info
}
# Mode at Prompt
function zle-line-init zle-keymap-select {
    # Show exit code on the right if it was != 0
    RPS1="%(?..[%B%?%b])%{%F{red}%}${vcs_info_msg_0_}%{$fg_bold[yellow]%}${${KEYMAP/vicmd/ -- NORMAL --}/(main|viins)/}%f%b"
    zle reset-prompt
}

zle -N zle-line-init
zle -N zle-keymap-select

# Vars used later on by Zsh
export EDITOR="vim"
export GIT_EDITOR="$EDITOR"
export IDE="gvim"
export BROWSER="w3m"

##################################################################
# Stuff to make life easier

# allow approximate
#zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*:*:cd:*' tag-order local-directories
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}"
autoload -U colors && colors
compinit

# This sets the case insensitivity
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}'

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# cd not select parent dir
zstyle ':completion:*:cd:*' ignore-parents parent pwd

zstyle ':completion:*' menu select
setopt menu_complete

##################################################################
# Key bindings
# http://mundy.yazzy.org/unix/zsh.php
# http://www.zsh.org/mla/users/2000/msg00727.html

typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^[[1~' beginning-of-line
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[4~' end-of-line
bindkey '^[[5~' history-search-backward
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char 
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix
bindkey '^r' history-incremental-search-backward
bindkey '^w' backward-kill-word

source ~/.zsh/custalias.zsh

set inc

export PATH=~/usr/bin:$PATH
export PATH=/usr/local/cuda-7.5/bin:$PATH
export LD_LIBRARY_PATH=~/usr/lib:$LD_LIBRARY_PATH

# vim CTRL-Z helper
fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    fg
    zle redisplay
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

#plugin part
setopt HIST_FIND_NO_DUPS
source ~/.zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

bindkey '^[[A' up-line-or-search   
bindkey '^[[B' down-line-or-search

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

export NDK_ROOT='/home/zackel/workspace/android/android-ndk-r10e'
export NDK_HOME='/home/zackel/workspace/android/android-ndk-r10e'
export ANDROID_HOME='/home/zackel/usr/adt-bundle-linux-x86_64-20131030/sdk'
