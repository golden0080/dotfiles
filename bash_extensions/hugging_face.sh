set -o physical

# define HF_ENABLED env and check whether it is set, if not, then exit
if [ -z "${HF_ENABLED+x}" ]; then
    return
fi

export HF_HOME="$HOME/vllm-models"
