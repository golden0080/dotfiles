set -o physical

# the script check CLAUDE_LOCAL - if it's set, then continue. Otherwise, return
if [[ -z "${CLAUDE_LOCAL}" ]]; then
  return
fi

# set the necessary CLAUDE envs to point to 127.0.0.1:8081/v1
export ANTHROPIC_API_KEY="local-model"
export ANTHROPIC_MODEL="qwen3.6-35B"
export CLAUDE_CODE_MAX_CONTEXT_TOKENS=262144
export ANTHROPIC_BASE_URL="http://192.168.1.188:8081"
export CLAUDE_CODE_ENABLE_TELEMETRY=0
export CLAUDE_CODE_ATTRIBUTION_HEADER=0
export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1
