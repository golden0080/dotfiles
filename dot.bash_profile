# Mark as loaded
export BASH_PROFILE_RUN=1

export EDITOR=vim
YELLOW='\[\033[36m\]'

# -------SSH---------

# -------Paths-------
function pro() {
    cd ~/projects/$1
}

# -------Python-------
alias py=python3
alias ve=virtualenv
alias ve3="mkvirtualenv --system-site-packages -p python3"
alias wo=workon
alias ove=deactivate

# -------virtualenvwrapper-------
export WORKON_HOME=$HOME/envs
export PROJECT_HOME=$HOME/projects
if [ -f ~/.local/bin/virtualenvwrapper.sh ]; then
    . ~/.local/bin/virtualenvwrapper.sh
fi

# -------utils-------
alias cdu="cd .."
alias w="pwd"
alias tm="tmux"
function tsize() {
    du -hs -c $1 | tail -n 1
}

function clean() {
    clipdel -d .*
}

# -------- Node JS -------
if [ -d "$HOME/.nvm" ]; then
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# -------- Misc ----------
alias audio=pulseaudio-ctl

xrandr --output DVI-1 --auto --output DVI-1-2 --auto --right-of DVI-1