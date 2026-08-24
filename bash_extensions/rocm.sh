ROCM_VERSION=7.2.4
ROCM_BIN=/opt/rocm-$ROCM_VERSION/bin
[[ -d $ROCM_BIN ]] || return

export PATH=$PATH:$ROCM_BIN
