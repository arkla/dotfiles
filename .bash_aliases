# for  tmux
export TERM=xterm-256color

## fancy PROMT
# we need this for __git_ps1
if [ -f ~/.git-prompt.sh ]; then
    . ~/.git-prompt.sh
fi
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1
export GIT_PS1_SHOWUPSTREAM="auto"

# seconds to nice string
function duration() {
  local E=$1
  local D=$((E/86400))
  if [ "$D" = 0 ]; then
    echo "$(date -u -d @"$E" +"%T")"
  elif [ "$D" = 1 ]; then
    echo "$D day, $(date -u -d @"$E" +"%T")"
  else
    echo "$D days, $(date -u -d @"$E" +"%T")"
  fi
}

# This will run before any command is executed.
function PreCommand() {
    if [ -z "$AT_PROMPT" ]; then
        return
    fi
    unset AT_PROMPT

    START_SECONDS=$SECONDS
}
trap "PreCommand" DEBUG

# This will run after the execution of the previous full command line.  We don't
# want it PostCommand to execute when first starting a bash session (i.e., at
# the first prompt).
FIRST_PROMPT=1
function PostCommand() {
    local EXIT="$?"

    AT_PROMPT=1

    PS1='${debian_chroot:+($debian_chroot)}\[\033[00m\]\[\033[1;34m\]\n\w\[\033[0;33m\]$(__git_ps1 " [%s]") \[\033[00m\][\u@\h] [\A]'

    if [ -n "$FIRST_PROMPT" ]; then
        unset FIRST_PROMPT
        # reset color and prompt on new line
        PS1+="\[\033[00m\]\n\$ "
        return
    fi

    # add duration of last cmd
    local elapsed=$(($SECONDS - $START_SECONDS))
    if [ $elapsed != 0 ]; then
        PS1+="\[\033[0;32m\] ["
        PS1+="$(duration $elapsed)"
        PS1+="]"
    fi

    # add exit code
    if [ $EXIT != 0 ]; then
        PS1+="\[\033[01;31m\] [$EXIT]"
    fi

    # reset color and prompt on new line
    PS1+="\[\033[00m\]\n\$ "
}
PROMPT_COMMAND="PostCommand"
# PROMPT done

# show colors in man pages
function man() {
  env \
  LESS_TERMCAP_mb=$(printf "\e[1;32m") \
  LESS_TERMCAP_md=$(printf "\e[1;32m") \
  LESS_TERMCAP_me=$(printf "\e[0m") \
  LESS_TERMCAP_se=$(printf "\e[0m") \
  LESS_TERMCAP_so=$(printf "\e[01;33m") \
  LESS_TERMCAP_ue=$(printf "\e[0m") \
  LESS_TERMCAP_us=$(printf "\e[1;4;31m") \
  man "$@"
}

# set system editor
export EDITOR=nvim

export PATH="/opt/MaskRay/ccls/Release:$PATH"
export PATH="~/.local/bin:$PATH"

# additional
[ -f ~/.bash_untracked ] && . ~/.bash_untracked
