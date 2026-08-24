set -o physical

[[ -d ~/mcp-servers ]] || return

export PATH="$HOME/mcp-servers:$PATH"
