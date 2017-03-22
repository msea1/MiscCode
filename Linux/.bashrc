# ~/.bashrc: executed by bash(1) for non-login shells.

force_color_prompt=yes


### ALIASES ###
alias addrep='sudo add-apt-repository'
alias bashrc='subl ~/.bashrc'
alias cd..="cd .."
alias code='cd ~/Code'
alias diskspace="du -S | sort -n -r |more"
alias docklist='docker ps -a --format "table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"'
alias dockstop='docker rm -f -v $(docker ps -a -q)'
alias g='git'
alias gitconfig='subl ~/.gitconfig'
alias h='history | grep'
alias inst='sudo apt-get install'
alias ld='ls -ABF --group-directories-first'
alias ll='ls -AhlF --group-directories-first'
alias mkdir='mkdir -pv'
alias py='python3'
alias root="sudo su -"
alias sorry='sudo $(fc -ln -1)'
alias update='sudo apt-get update'
alias upgrade='sudo apt-get upgrade'
alias vauth='vault auth -method=ldap username=$USER'
alias vssh='vault ssh -role otp_key_role'
alias wget='wget -c'


### CASES / CONDITIONALS ###

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
  # We have color support; assume it's compliant with Ecma-48
  # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
  # a case would tend to support setf rather than setaf.)
  color_prompt=yes
    else
  color_prompt=
    fi
fi


if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\] $(parse_git_branch)\[\033[00m\] \$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w $(parse_git_branch) \$ '
fi
unset color_prompt force_color_prompt

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

if [[ -f ~/.git-completion.bash ]]; then
    source ~/.git-completion.bash
fi
complete -o default -o nospace -F _git g

### COLORS ###
BLUE="\033[38;5;39m\]"
GREEN="\033[38;5;47m\]"
GREY="\033[38;5;7m\]"
WHITE="\033[38;5;15m\]"
YELLOW="\033[38;5;11m\]"

### ENVIRONMENT VARIABLES ###
export DJANGO_ENV=development
export EDITOR=vim
export HISTCONTROL=ignoreboth
export HISTSIZE=1000
export HISTFILESIZE=2000
export PS1="\[$BLUE[\w] \[$(tput sgr0)\]\[$GREEN\$(parse_git_branch) \[$(tput sgr0)\]\[$WHITE\\$ \[$(tput sgr0)\]"
export REQUEST_CA_BUNDLE=/usr/local/share/ca-certificates/gd_bundle-g2.crt
export VAULT_ADDR=https://vault.prod.blacksky.com:8200
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3
export WORKON_HOME=$HOME/.virtualenvs


### FUNCTIONS ###

add_local_path() {
    export PYTHONPATH=$PYTHONPATH:.
    export PYTHONPATH=$PYTHONPATH:$VIRTUAL_ENV/lib/python3.6/site-packages
    echo $PYTHONPATH
}

cdl() {
    builtin cd "${@}"
    if [ "$( ls | wc -l )" -gt 30 ] ; then
        ls --color=always | awk 'NR < 16 { print }; NR == 16 { print " (... snip ...)" }; { buffer[NR % 14] = $0 } END { for( i = NR + 1; i <= NR+14; i++ ) print buffer[i % 14] }'
    else
        ls
    fi
}

code_rvw() {
  echo "erybczynski, MBlondeel, JHersch, LTaylor, jbrazel, CPeel" | xsel -ib
  arc diff $1
}

colors() {
    for i in {0..31} ; do echo "[7;(38;05;$i)mColor $i [0m    [7;(38;05;$(($i + 32)))mColor $(($i+32)) [0m  [7;(38;05;$(($i+64)))mColor $(($i+64)) [0m    [7;(38;05;$(($i + 96)))mColor $(($i+96)) [0m  [7;(38;05;$(($i+128)))mColor $(($i+128)) [0m  [7;(38;05;$(($i + 160)))mColor $(($i+160)) [0m    [7;(38;05;$(($i+192)))mColor $(($i+192)) [0m  [7;(38;05;$(($i + 224)))mColor $(($i+224))"; done; echo -n "[0m"
}

docker_clean(){
    docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
    docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

docker_kill(){
  sudo systemctl stop docker
  sudo rm /var/lib/docker/linkgraph.db
  sudo rm -rf /var/lib/docker/containers/
  sudo systemctl start docker
}

docker_local(){
  rsync -a --exclude='.*' ./ $HOME/code/devops/docker/sources/$1/
  cd $HOME/code/devops/docker
  sudo docker build -t $2 -f dockerfiles/$2.docker .
  cd -
}

extract () {
 if [ -f $1 ] ; then
     case $1 in
         *.tar.bz2)   tar xvjf $1    ;;
         *.tar.gz)    tar xvzf $1    ;;
         *.bz2)       bunzip2 $1     ;;
         *.rar)       unrar x $1       ;;
         *.gz)        gunzip $1      ;;
         *.tar)       tar xvf $1     ;;
         *.tbz2)      tar xvjf $1    ;;
         *.tgz)       tar xvzf $1    ;;
         *.zip)       unzip $1       ;;
         *.Z)         uncompress $1  ;;
         *.7z)        7z x $1        ;;
         *)           echo "don't know how to extract '$1'..." ;;
     esac
 else
     echo "'$1' is not a valid file!"
 fi
}

get_certs() {
  cd ~
  wget http://confluence.spaceflightindustries.com/download/attachments/6230825/cert.tgz?version=1&modificationDate=1453854699441&api=v2
  sudo tar zxvf cert.tgz -C /usr/local/share/ca-certificates
  rm cert.tgz
  sudo dpkg-reconfigure ca-certificates
  update-ca-certificates
  cd -
}

gps() {
  arg=$1
  letter=${arg:0:1}
  brack='['$letter']'
  srch=$brack${arg:1}
  ps -ax | grep -i $srch
}

ipy_note() {
  cd $HOME/Code/jupyter_notebooks
  workon jupyter
  jupyter notebook
  deactivate
  cd -
}

work() {
  source $WORKON_HOME/$1/bin/activate
}

new_venv() {
  py -m venv $2 $WORKON_HOME/$1
  work $1
}

parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

up(){
  local d=""
  limit=$1
  for ((i=1 ; i <= limit ; i++))
    do
      d=$d/..
    done
  d=$(echo $d | sed 's/^\///')
  if [ -z "$d" ]; then
    d=..
  fi
  cd $d
}

start_vpn() {
    cd ~/Code/vpn
    sudo cp vpn_resolv.conf /etc/resolv.conf
    sudo openvpn pfSense-udp-1195.ovpn
    cd -
}

start_moc_vpn() {
    cd ~/Code/vpn/moc
    sudo cp moc_vpn_resolv.conf /etc/resolv.conf
    sudo openvpn linux-1.ovpn
    cd -
}


### HTML ###



### OPTIONS ###
shopt -s cdspell  # Autocorrect fudged paths in cd calls
shopt -s checkwinsize
shopt -s cmdhist
shopt -s dotglob
shopt -s extglob
shopt -s histappend

set completion-ignore-case On

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


### PATHS ###

export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH="$PATH:$HOME/bin/arc/arcanist/bin"

export PYTHONPATH="$HOME/Code/"
export PYTHONPATH=$PYTHONPATH:.
