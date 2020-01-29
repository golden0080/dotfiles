set -o physical

export EDITOR=vim
YELLOW='\[\033[36m\]'

# -------Paths-------
function pro() {
    cd ~/projects/$1
}

# -------utils-------
alias cdu="cd .."
# alias w="pwd"
# alias tm="tmux"
alias audio=pulseaudio-ctl

function tsize() {
    du -hs -c $1 | tail -n 1
}

alias clean="greenclip clear"
