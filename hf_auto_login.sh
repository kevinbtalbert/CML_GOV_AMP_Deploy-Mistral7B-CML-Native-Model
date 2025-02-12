#!/bin/bash

# Ensure HF_ACCESS_TOKEN is set
if [ -z "$HF_ACCESS_TOKEN" ]; then
  echo "Error: HF_ACCESS_TOKEN environment variable is not set."
  exit 1
fi

# Log in to Hugging Face CLI without user interaction
echo "$HF_ACCESS_TOKEN" | huggingface-cli login --token
