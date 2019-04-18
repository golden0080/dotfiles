# CUDA environment variables for GTX10 series
export TF_NEED_CUDA=1
export TF_CUDA_COMPUTE_CAPABILITIES=6.1

export PATH="/usr/local/cuda/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda/extras/CUPTI/lib64/"
