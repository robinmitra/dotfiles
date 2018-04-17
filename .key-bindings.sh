# Sets up key bindings for custom functions (defined in .functions.sh).
# The git bindings are taken from https://junegunn.kr/2016/07/fzf-git
#
# Authors:
#   Robin Mitra <robinmitra1@gmail.com>
#

#######
# Git #
#######

join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-helper() {
  local char
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(fn-g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
}
bind-git-helper f b t r h
unset -f bind-git-helper
