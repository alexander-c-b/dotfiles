source $HOME/.profile

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# Append `../` to your input for each `.` you type after an initial `..`
zstyle ':zim:input' double-dot-expand yes

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# ------------------
# Initialize modules
# ------------------

if [[ ${ZIM_HOME}/init.zsh -ot ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  # Update static initialization script if it's outdated, before sourcing it
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh


# Define zim location
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

# Start zim
[[ -s ${ZIM_HOME}/init.zsh ]] && source ${ZIM_HOME}/init.zsh

# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/home/zander/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=500
SAVEHIST=1000
setopt appendhistory
bindkey -v
# End of lines configured by zsh-newuser-install

# direnv
if which direnv 1> /dev/null
then
    eval "$(direnv hook zsh)"
fi

source $HOME/.config/zsh/zsh-nix-shell/nix-shell.plugin.zsh
source /home/zander/.config/zsh/zsh-vim-mode/zsh-vim-mode.plugin.zsh

autoload -z edit-command-line
zle -N edit-command-line
bindkey -M vicmd ' ' edit-command-line

export GHCHOME="$HOME/.ghc"
export LESS=FX

# ------------
# Conveniences
# ------------
#
export fnixos="-f '<nixos>'"
export fnixpkgs="-f '<nixpkgs>'"

function nixr {
    nixr_1="$1"
    shift
    nix run -f '<nixos>' $nixr_1 -c $(sed -E 's/.*?\.//' <<< $nixr_1) $@
}

alias nixi="nix-env -f '<nixos>' -iA"
alias nvimd="nvim +'set filetype=pmarkdown'"

function count { printf $'%s\n' $#; }
alias gis="git status"
alias gia="git add"
alias gid="git diff"
alias gic="git checkout"
alias gicb="git checkout -b"
alias gilog="git log --oneline -n3"
function gicm  { message="$@"; git commit -m "$message"; }
function cdgit { cd $(git rev-parse --show-toplevel); }
function gian  {
    files=$(git status \
            | sed '1,/Untracked/d' \
            | grep -Po '\t\K[^" ]*')
    if [ -n "$files" ]; then
        xargs -d'\n' git add <<< $files
        git commit -m "added $(awk 1 ORS=', ' <<< $files | sed 's/, $//')"
    fi
}

alias gitdotfiles='$(which git) --git-dir=$HOME/.dotfiles.git --work-tree=$HOME'
alias gd=gitdotfiles
alias gds="gitdotfiles status"
alias gda="gitdotfiles add"
alias gdc="gitdotfiles checkout"
alias gdcb="gitdotfiles checkout -b"
alias gdd="gitdotfiles diff"
alias gdlog="gitdotfiles log --oneline -n3"
function gdcm { message="$@"; gitdotfiles commit -m "$message"; }
alias xargsl="xargs -d'\n' -I{}"
function into { mkdir -p "$@" && cd "$1"; }

record () { arecord -dat $1.wav <&1; ffmpeg -i $1.wav $1.flac; }

alias calculator="ghci ~/scripts/functions.hs"

# These are bash's default ls colors on 2019 05 21.
# export LS_COLORS="di=1;34:ln=35:so=32:pi=33:ex=31:bd=1;36:cd=1;33:su=30;41:sg=30;46:tw=30;42:ow=30;43"
alias ls='ls --color=auto'
alias diff='diff --color=auto'

KEYTIMEOUT=10

case $USERNAME in
    zander)
        case $HOST in
            z-nixos-desktop) psvar=("") ;;
            *) psvar=($HOST) ;;
        esac
        ;;
    *)
        case $HOST in
            z-nixos-desktop) psvar=($USERNAME) ;;
            *) psvar=("$USERNAME@${psvar[0]}") ;;
        esac
        ;;
esac
if [[ -n ${psvar[0]} ]]; then psvar[1]=":" fi

nix_shell=${NIX_SHELL_PACKAGES:+"{ $NIX_SHELL_PACKAGES } "}
PROMPT="${nix_shell}%{%F{green}%}%v%{%f%} %{%F{blue}%}%(4~|%-1~/…/%2~|%3~)%{%f%} %# "

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

bindkey '^J' history-substring-search-down
bindkey '^K' history-substring-search-up
bindkey -M vicmd 'k'  history-substring-search-up
bindkey -M vicmd 'j'  history-substring-search-down
bindkey -M vicmd '^J' history-substring-search-down
bindkey -M vicmd '^K' history-substring-search-up
bindkey '^N' expand-or-complete
bindkey '^P' reverse-menu-complete

export VISUAL=nvim
export EDITOR=$VISUAL

function zle-keymap-select zle-line-init
{
    # change cursor shape
    if [[ -n "$TMUX" ]]; then  # tmux
      case $KEYMAP in
          vicmd)      print -n '\033[0 q';; # block cursor
          viins|main) print -n '\033[6 q';; # line cursor
      esac
    else # iTerm2
      case $KEYMAP in
          vicmd)      print -n -- "\1\e[2 q\2";;  # block cursor
          viins|main) print -n -- "\1\e[6 q\2";;  # line cursor
      esac
    fi

    zle reset-prompt
    zle -R
}

function zle-line-finish
{
    if [[ -n "$TMUX" ]]; then # tmux
      print -n -- '\033[0 q'  # block cursor
    else # iTerm2
      print -n -- "\1\e[2 q\2"  # block cursor
    fi
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select
