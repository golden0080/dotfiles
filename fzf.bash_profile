# Setup fzf
# ---------
if [[ ! "$PATH" == */home/gh/.fzf/bin* ]]; then
  export PATH="$PATH:/home/gh/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/gh/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/gh/.fzf/shell/key-bindings.bash"

# My customizations
export FZF_DEFAULT_OPTS="--extended --border"

export FZF_COMPLETION_TRIGGER='--'

export FZF_DEFAULT_COMMAND='fd -d 8'

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

cdf() {
    local file
    local dir
    file=$(fzf +m -q "$1") && dir=$(dirname "$file") && cd "$dir"
}
