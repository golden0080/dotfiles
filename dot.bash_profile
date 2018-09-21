# Mark as loaded
export BASH_PROFILE_RUN=1

export EDITOR=vim
YELLOW='\[\033[36m\]'

# -------SSH---------
alias zenossh="ssh -i ${HOME}/Documents/aws/zeno.pem ubuntu@zeno.turingvideo.com"
alias devzenossh="ssh -i ${HOME}/Documents/aws/dev-zeno.pem ubuntu@dev-zeno.turingvideo.com"
alias statsssh="ssh -i ${HOME}/Documents/aws/stats.pem ubuntu@stats.turingvideo.com"
alias webssh="ssh -i ${HOME}/Documents/aws/web.pem ubuntu@www.turingvideo.com"
alias sitessh="ssh -i ${HOME}/Documents/aws/index.pem ubuntu@www.zumavp.com"

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
source /home/gh/.local/bin/virtualenvwrapper.sh

# -------utils-------
alias cdu="cd .."
alias ll="ls -l"
alias w="pwd"
alias tm="tmux"
alias rem="inv -r ~/projects/gh-tools/"
function tsize() {
    du -hs -c $1 | tail -n 1
}
alias install_robot="bash ~/projects/gh-tools/robot/install.sh"

function clean() {
    clipdel -d .*
}

# -------PS1--------
# If PS1 is not set at all, this is not an interactive
# shell and we should not mess with it.
if [ -n "$PS1" ]; then
    # A temporary variable to contain our prompt command
    NEW_PROMPT_COMMAND='TRIMMED_PWD=${PWD: -30}; TRIMMED_PWD=${TRIMMED_PWD:-$PWD}'

    # If there's an existing prompt command, let's not
    # clobber it
    if [ -n "$PROMPT_COMMAND" ]; then
        PROMPT_COMMAND="$PROMPT_COMMAND;$NEW_PROMPT_COMMAND"
    else
        PROMPT_COMMAND="$NEW_PROMPT_COMMAND"
    fi

    # We're done with our temporary variable
    unset NEW_PROMPT_COMMAND

    # Set PS1 with our new variable
    # \h - hostname, \u - username
    PS1='\[\033[36m\]\u:\[\033[33m\]$TRIMMED_PWD \$ \[\033[0m\]'
fi

# -------OpenCV 3--------
export PATH="/usr/local/opt/opencv3/bin:$PATH"
export PATH="/usr/local/opt/opencv3/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# -------- Node JS -------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
export PATH="/usr/local/opt/qt/bin:$HOME/local/bin:$PATH"
