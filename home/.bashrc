# shellcheck shell=bash
# vim: ft=bash

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

bslcb() {
    RETVL=$?
    [ -n "$BSLNFC" ] &&
        {
            BSLMT="$(
                history 1 |
                    sed 's/^ *//;s/ /]/'
            ) [$RETVL]"
        } ||
        BSLMT=']'
    BSLMT="$(date +'%Y-%m-%d, %H:%M:%S') [$$-$BSLMT"

    # pick your poison
    #logger -p local6.debug "$BSLMT"
    printf '%s\n' "$BSLMT" >>~/.local/share/bash.log

    [ -n "$BSLNFC" ] &&
        {
            if [ "$RETVL" -eq 0 ]; then
                echo
            else
                printf '\n\033[1;31mError Code:\033[0;1m %s\033[0m\n' "$RETVL"
            fi

            bash -c 'stat .' 2>&1 | command grep -qE 'No such file or directory|Links: 0[ $]' &&
                {
                    echo -e "\033[1;33mWARNING\033[0m: Current directory does not exist anymore."
                    if cd "$BSLNFC" 2>/dev/null; then
                        printf '\033[1;32mNOTICE:\033[0m Recovered pwd: %s\n' "$(pwd)"
                    else
                        printf '\033[1;31mALERT:\033[0m Could not recover pwd\n'
                    fi
                }
        }
    BSLNFC="$(pwd)"
}
PROMPT_COMMAND=bslcb

source_if_exists() {
    local arg
    for arg; do
        [[ $arg == -* ]] && continue
        [[ -f $arg ]] || return
    done
    # shellcheck disable=SC1090
    source "$@"
}

# vi mode
set -o vi

# Clear screen
bind -m vi-insert 'Control-l: clear-screen'
bind -m vi-command 'Control-l: clear-screen'

# XDG Setup
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

source_if_exists "$XDG_CONFIG_HOME/bash/xdg"
source_if_exists "$XDG_CONFIG_HOME/bash/path"
source_if_exists "$XDG_CONFIG_HOME/bash/sources"
source_if_exists "$XDG_CONFIG_HOME/bash/colors"
source_if_exists "$XDG_CONFIG_HOME/bash/aliases"
source_if_exists "$XDG_CONFIG_HOME/bash/functions"
source_if_exists "$XDG_CONFIG_HOME/bash/clipboard"
source_if_exists "$XDG_CONFIG_HOME/bash/history"
source_if_exists "$XDG_CONFIG_HOME/bash/less"
source_if_exists "$XDG_CONFIG_HOME/bash/personal"

PS1="\
\[\033[1;30m\]-\
\[\033[1;35m\]\$?\
\[\033[1;30m\]-\
\[\033[1;31m\]\$(date +%H%M%S)\
\[\033[1;30m\]-\
\[\033[1;33m\]\u\
\[\033[1;30m\]-\
\[\033[1;32m\]\h\
\[\033[1;30m\] <\
\[\033[1;34m\]\w\
\[\033[1;30m\]> \
\[\033[0m\]\n"

tty | command grep -q /tty &&
    {
        #cat bifrost.html | command grep 'background:#' | sed -r 's/.*#//;s/".*//' | awk 'FNR%9==0 {print ""} {printf "\\033]P%x%s", n, $1; n+=1}' | sed 's/404040/202020/;s/606060/505050/'
        printf '\033]P0202020\033]P1f03669\033]P2b8e346\033]P3ffa402\033]P402a2ff\033]P5f65be3\033]P63da698\033]P7d2d2d2'
        printf '\033]P8505050\033]P9c75b79\033]Pac8e37e\033]Pbffbe4a\033]Pc71cbff\033]Pdb67fe3\033]Pe9cf0ed\033]Pfffffff'
        printf '\033[J'
    }
true
