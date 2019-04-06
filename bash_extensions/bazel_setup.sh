[[ -d ~/.bazel/bin ]] || return

source $HOME/.bazel/bin/bazel-complete.bash
export PATH="$HOME/bin:$PATH"
