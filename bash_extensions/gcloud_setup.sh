[[ -d ~/google-cloud-sdk ]] || return

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/guanghui/google-cloud-sdk/path.bash.inc' ]; then . '/home/guanghui/google-cloud-sdk/path.bash.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/guanghui/google-cloud-sdk/completion.bash.inc' ]; then . '/home/guanghui/google-cloud-sdk/completion.bash.inc'; fi
