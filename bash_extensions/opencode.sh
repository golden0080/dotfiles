set -o physical

# the script checks for opencode - if it's not installed, then return
if ! command -v opencode &>/dev/null; then
  return
fi

# set the necessary OPENCODE envs to point to 192.168.1.188:8081/v1
export OPENCODE_DISABLE_AUTOUPDATE=1
export OPENCODE_DISABLE_SHARE=1
export OPENCODE_ENABLE_EXA=1
