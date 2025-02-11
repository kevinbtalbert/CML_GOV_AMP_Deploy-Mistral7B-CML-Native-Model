#!/bin/bash

export MISTRAL_MODEL=$HOME/mistral_models
mkdir -p $MISTRAL_MODEL
export M7B_DIR=$MISTRAL_MODEL/7b_instruct

# Download the file using curl
curl -o mistral-7B-Instruct-v0.3.tar https://models.mistralcdn.com/mistral-7b-v0-3/mistral-7B-Instruct-v0.3.tar

mkdir -p $M7B_DIR  # Corrected variable usage
tar -xf mistral-7B-Instruct-v0.3.tar -C $M7B_DIR
