#!/bin/bash
# Llama server with Qwen3-Coder-Next-UD-IQ3_S model
cd "$(dirname "$0")"

export GGML_OP_OFFLOAD_MIN_BATCH=4096
llama-server \
  -m unsloth-Qwen3-Coder-Next-UD-IQ3_S.gguf \
  -a Qwen3-Coder-Next-GGUF \
  -fa on \
  -c 256000 \
  -np 2 \
  -cb \
  -b 4096 \
  -ub 2048 \
  --host 0.0.0.0 \
  --port 8081 \
  -ngl 41 \
  --n-cpu-moe 2 \
  --no-mmap \
  --cache-ram 3072 \
  --jinja \
  --threads-http 1
