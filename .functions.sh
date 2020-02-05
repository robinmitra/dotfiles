# Defines custom functions, prefixed with 'fn-' (bindings defined in .key-bindings.sh).
# The git functions using FZF are taken from https://junegunn.kr/2016/07/fzf-git
#
# Authors:
#   Robin Mitra <robinmitra1@gmail.com>
#

###########
# General #
###########

# Create a new directory and enter it.
function md() {
	mkdir -p "$@" && cd "$@"
}

#######
# Git #
#######

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

function setup-gpg() {
  is_in_git_repo || return 
  if [[ -z $1 ]]; then
    EMAIL=$(git config user.email)
  else
    EMAIL=$(gpg --list-secret-keys --keyid-format LONG $1 | sed -n '3p' | cut -d '<' -f 2 | cut -d '>' -f 1)
  fi
  echo Setting up GPG key for email \'$EMAIL\' as commit signing key for this repo.
  git config user.signingKey $(gpg --list-secret-keys --keyid-format LONG $EMAIL | cut -d ' ' -f 4 | cut -d '/' -f 2 | sed -n '1p')
  echo GPG key with ID \'$(git config user.signingKey)\' set.
}

function setup-work-repo() {
  git config user.email "robin.mitra@digital.cabinet-office.gov.uk"
  setup-gpg
}

function setup-personal-repo() {
  git config user.email "robinmitra1@gmail.com"
  setup-gpg
}

function aws-login() {
  if [[ $1 == "work" ]]; then
    echo "Logging into your work AWS account."
    aws-vault login --mfa-token=$(ykman oath code -s gds-users) govwifi
  else
    echo "Logging into your personal AWS account."
    aws-vault login --mfa-token=$(ykman oath code -s robin) robin
  fi
}

fzf-down() {
  fzf --height 50% "$@" --border
}

fn-gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' |
  cut -c4- | sed 's/.* -> //'
}

fn-gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

fn-gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

fn-gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

fn-gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}
