export PHOME=$HOME/projects/IkeAV
alias phome="cd $PHOME"

function bzrun() {
    $PHOME/bazel-bin/$1
}
