which python >> /dev/null || which python3 >> /dev/null || return

alias py3=python3
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
