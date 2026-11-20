#!/bin/zsh

# Environment
#############

export EDITOR='nvim'
export VISUAL='nvim'
export ANSIBLE_NOCOWS=1
export GOPATH=$HOME/go

typeset -U path
path=(
  ~/bin
  ~/.bin
  $GOPATH/bin
  $path
)

if [[ -d /opt/homebrew/opt/openjdk ]]; then
  path=(/opt/homebrew/opt/openjdk/bin $path)
  export JAVA_HOME="/opt/homebrew/opt/openjdk"
fi

# uv and friends
[[ -f "$HOME/.local/bin/env" ]] && . "$HOME/.local/bin/env"

# use .localrc for machine-specific or secret things you don't want in the
# repo, e.g. PROMPT_TAG
[[ -f ~/.localrc ]] && source ~/.localrc

# Prezto (also runs compinit)
#############################

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Shell options
###############

unsetopt correct correct_all
unsetopt share_history
setopt clobber

bindkey '^R' history-incremental-search-backward
bindkey '^E' end-of-line
bindkey '^A' beginning-of-line

# Prompt
########

setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
    '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats       \
    '%F{4}%s%F{3}%F{2}:%F{4}%F{2}%b%F{5}%f '
zstyle ':vcs_info:*' enable git

vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}"
  fi
}

venv_info_wrapper() {
    if [ -n "$VIRTUAL_ENV" ]; then
        local _virtualenv_path
        _virtualenv_path=(${(s:/:)VIRTUAL_ENV})
        echo "($_virtualenv_path[-1])"
    fi
}

dir_info_wrapper() {
    local _cwd
    local _dir
    local _path
    local _dirs
    local _under_home
    local _path_pieces
    _path_pieces=()
    _under_home=false
    _cwd="$(pwd)"

    if [[ "$_cwd" =~ ^"$HOME"(/|$) ]]; then
        _cwd="~${$(pwd)#$HOME}"
        _under_home=true
    fi

    _dirs=(${(s:/:)_cwd})

    for _dir in $_dirs; do
        _path_pieces+="$_dir[1]"
    done

    _path_pieces[-1]=$_dirs[-1]

    for _piece in $_path_pieces; do
        _path+="/$_piece"
    done

    if [ "$_path" = "" ]; then
        _path='/'
    fi

    if [ "$_under_home" = true ]; then
        _path[1]=""
    fi

    echo "$_path"
}

PROMPT='$(venv_info_wrapper)%F{6}$(dir_info_wrapper)%f %F{9}❯%F{3}❯%F{2}❯%f '
RPROMPT=$'$(vcs_info_wrapper)'

# Label machines that need to look different, e.g. PROMPT_TAG=work in
# ~/.localrc on the work laptop.
if [[ -n "$PROMPT_TAG" ]]; then
  PROMPT="%K{1}%F{15}%B $PROMPT_TAG %b%f%k $PROMPT"
fi

# Aliases
#########

alias g='git'
alias c='clear'
alias nv='nvim'
command -v nvim >/dev/null 2>&1 && alias vim='nvim'
alias reload!='source ~/.zshrc'
alias py='python3'
alias pyserv='python3 -m http.server'

if [[ "$OSTYPE" == linux* ]] && command -v wl-copy >/dev/null 2>&1; then
  alias pbcopy='wl-copy'
  alias pbpaste='wl-paste'
fi

# Functions
###########

# Remove python compiled byte-code in either current directory or in a
# list of specified directories
pyclean() {
    local places=${*:-'.'}
    noglob find ${=places} -type f -name "*.py[co]" -delete
    noglob find ${=places} -type d -name "__pycache__" -delete
}

colours() {
  for i in {0..255} ; do
      printf "\x1b[38;5;${i}mcolour${i}\n"
  done
}

# Tool integrations
###################

# zoxide - the fasd/autojump replacement.
# z <partial dir>  jump to best match     zi <partial>  fzf picker
# z foo bar        match on multiple bits  z -          previous dir
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if command -v oc >/dev/null 2>&1; then
  source <(oc completion zsh)
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
