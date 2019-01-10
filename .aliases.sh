# Defines aliases.
#
# Authors:
#   Robin Mitra <robinmitra1@gmail.com>
#

#############
# Variables #
#############

export WORK=~/Code/work
export PLAY=~/Code/play

###########
# General #
###########

alias cp="cp -v"
alias mv="mv -v"
alias rm="rm -v -i"
alias freq-cmd="cat ~/.zhistory | cut -d ';' -f 2- | awk {'print \$1'} | sort | uniq -c | sort -r | head -20"
alias freq-subcmd="cat ~/.zhistory | cut -d ';' -f 2- | awk {'print \$1,\$2'} | sort | uniq -c | sort -r | head -20"
alias ssh-config="vim ~/.ssh/config"
alias hosts="cat /etc/hosts"
alias edit-hosts="sudo $EDITOR /etc/hosts"
alias c="highlight -O ansi -l" # in other words, a better 'cat'.
alias dspace="df -Hl" # H: human-format (with base 10), l: local mounts only.
alias fsize="stat -f \"%z bytes\""

#######
# ZSH #
#######

alias zr="source ~/.zshrc"
alias zc="vim ~/.zshrc"
alias zp="vim ~/.zpreztorc"
alias za="vim ~/.aliases.sh"

############
# Homebrew #
############

alias brewfile="$EDITOR ~/Brewfile"

#############
# Locations #
#############

alias work="cd $WORK"
alias play="cd $PLAY"

#######
# Git #
#######

alias gpo="gp origin"
alias glog="git log --color --graph --pretty=format:'%Cred%h%Creset %C(dim white)▹%Creset %C(green)%cr%Creset %C(dim green)%cd%Creset %C(dim white)▹%Creset %C(magenta)%an %C(dim magenta)<%ae>%Creset %C(dim white)▹%Creset %C(cyan)%G?%Creset %C(dim cyan)%GS%GK%Creset %C(auto)%+D%Creset %n%s%n' --date=format:'%a %d %b %y, %H:%m'"
alias glogc="git log --color --graph --pretty=format:'%Cred%h%Creset%C(yellow)%d%Creset %C(dim white)▹%Creset %s %C(dim white)▹%Creset %Cgreen%cr%Creset %C(dim white)▹%Creset %C(magenta)%an%Creset %C(dim white)▹%Creset %C(cyan)%G?%Creset'"
alias gla="git config -l | grep alias | cut -c 7-"
alias gtag="git log --tags --color --graph --simplify-by-decoration --pretty=format:'%C(green)%cr%Creset %C(dim green)%cd%Creset %C(auto)%D%Creset' --date=format:'%a %d %b %y, %H:%m'"

##############
# Kubernetes #
##############

alias kpods="kubectl get pods -o custom-columns=NAME:.metadata.name,READY:.status.containerStatuses[*].ready,STATUS:.status.phase,RESTARTS:.status.containerStatuses[*].restartCount,START:.status.startTime,IP:.status.podIP,NODE:.spec.nodeName,VERSION:.metadata.resourceVersion,IMAGE:.status.containerStatuses[*].image,LABELS:.metadata.labels"

############
# Suffixes #
############

alias -s go=goland
alias -s java=idea
alias -s js=webstorm
alias -s json=vim
alias -s {md,MD}='highlight -O ansi -l --syntax markdown'
alias -s php=pstorm
alias -s py=charm
alias -s rb=mine
alias -s xml=vim
