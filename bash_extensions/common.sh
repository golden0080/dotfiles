set -o physical

export EDITOR=vim
YELLOW='\[\033[36m\]'

# -------Paths-------
function pro() {
    if [ -z "$1" ]; then
        cd ~/projects
    else
        cd ~/projects/$1
    fi
}

function _pro_completions() {
    local cur
    cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=( $(compgen -W "$(ls -d ~/projects/*/ 2>/dev/null | xargs -n1 basename)" -- "$cur") )
}
complete -F _pro_completions pro

# -------utils-------
alias cdu="cd .."
# alias w="pwd"
# alias tm="tmux"
alias audio=pulseaudio-ctl

function tsize() {
    du -hs -c $1 | tail -n 1
}

alias clean="greenclip clear"
