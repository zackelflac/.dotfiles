##################################################################
# Aliases

# Set up auto extension stuff
alias -s net=$BROWSER
# alias -s torrent="qbittorrent"
alias -s gz=tar -xzvf
#alias -s bz2=tar -xjvf
alias -s PKGBUILD=$EDITOR
alias xterm='xterm -fg white -bg black'

# Normal aliases
case `uname` in
  Darwin)
alias ls='ls -GFh'
  ;;
  Linux)
alias ls='ls --color=auto -Fh'
  ;;
  FreeBSD)
    # commands for FreeBSD go here
  ;;
esac
#alias lsd='ls -ld *(-/DN)'
#alias lsa='ls -ld .*'
alias f='find -type f | xargs grep'
alias c="clear"
alias ..='cd ..'
#alias ppp-on=' /usr/sbin/ppp-on'
#alias ppp-off=' /usr/sbin/ppp-off'
alias hist="grep '$1' ~/.zsh_history"
#alias irssi="irssi -c irc.freenode.net -n yyz"
alias mem="free -m"

# command L equivalent to command |less
alias -g L='|less'

# command S equivalent to command &> /dev/null &
alias -g N='&> /dev/null &'

alias sshfs='sshfs -C -o reconnect -o workaround=all'

alias sifconfig='sudo ifconfig'
alias siptables='sudo iptables'
alias sai='sudo aptitude install'
alias aS='aptitude search'
alias saR='sudo aptitude remove'
alias sau='sudo aptitude update'
alias saup='sudo aptitude update && sudo aptitude safe-upgrade'
alias e=$IDE
alias v=$EDITOR
alias sv='sudo $EDITOR'
alias com='git commit -am'
alias push='git push'
alias pull='git pull'
alias ocaml='rlwrap ocaml'

alias smount="sudo mount"
alias sumount="sudo umount"
alias srcconf="sudo rcconf"
alias pwdb="pwman3"
alias sshut="sudo shutdown -h 0"
alias shibern="sudo pm-hibernate"
alias sreboot="sudo reboot"

alias arduino="arduino-asm&"
alias mc='mw gmake -j4'
alias mc='mw gmake -j4 check'

alias l="ranger"
alias ll="ls -al"
alias du="du -h"
alias df="df -h"

alias vimrc="vim ~/.vimrc"
alias zshrc="vim ~/.zshrc"
alias indrc="vim ~/.indexer_files"

alias er="gvim --servername GVIM --remote"
alias ers="gvim --servername GVIM"
alias edebug="gvim --cmd 'let debug=1'"
alias vdebug="vim --cmd 'let debug=1'"
alias vdev="vim --cmd 'let indexing=1' --servername VIM"
alias vimdev="vim --cmd 'let indexing=1' --servername VIM"

alias alert_helper='history|tail -n1|sed -e "s/^\s*[0-9]\+\s*//" -e "s/;\s*alert$//"'
alias alert='notify-send -i /usr/share/icons/gnome/32x32/apps/gnome-terminal.png "[$?] $(alert_helper)"'

if type "colordiff" > /dev/null; then
  alias diff="colordiff"
fi

# Go back (..) n times
cdn () { pushd .; for ((i=1; i<=$1; i++)); do cd ..; done; pwd; }
# Go up until reaching $1, ie: cdu home
cdu () { cd "${PWD%/$1/*}/$1"; }

function mwfindPath () {
    mw ch findPath -c $1 $2 -f DOT | dot -Tx11
}

function mwctb () {
    mw gmake -j4 COMPONENTS_TO_BUILD=$1
}

function ranger() {
    if [ -z "$RANGER_LEVEL" ]; then
        /usr/bin/ranger "$@"
    else
        exit
    fi
}
