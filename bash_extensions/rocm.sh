ROCM_VERSION=6.4.2
ROCM_BIN=/opt/rocm-$ROCM_VERSION/bin
[[ -d $ROCM_BIN ]] || return

export PATH=$PATH:$ROCM_BIN
