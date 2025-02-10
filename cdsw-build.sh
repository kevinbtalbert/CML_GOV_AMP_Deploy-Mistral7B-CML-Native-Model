#!/bin/bash

# Copyright 2025 Cloudera Government Solutions, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

### INSTALL CUDA 12.4 AND NVIDIA DRIVERS ###

# Create directory for the NVIDIA installer
mkdir -p $HOME/nvidia-installer

# Download the CUDA 12.4 installer
curl -o $HOME/nvidia-installer/cuda_12.4.0_535.104.05_linux.run \
     https://developer.download.nvidia.com/compute/cuda/12.4.0/local_installers/cuda_12.4.0_535.104.05_linux.run

# Create the directory to install CUDA
mkdir -p ~/cuda

# Run the CUDA installer
bash $HOME/nvidia-installer/cuda_12.4.0_535.104.05_linux.run --no-drm --no-man-page --override --toolkitpath=$HOME/cuda --toolkit --silent

# Set CUDA environment variables
export PATH=${PATH}:$HOME/cuda/bin:$HOME/cuda/nvvm
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$HOME/cuda/lib64:$HOME/cuda/nvvm/lib64:$HOME/cuda/nvvm
export CUDA_HOME=$HOME/cuda

# Persist the environment variables for future sessions
echo 'export PATH=${PATH}:$HOME/cuda/bin:$HOME/cuda/nvvm' >> ~/.bashrc
echo 'export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$HOME/cuda/lib64:$HOME/cuda/nvvm/lib64:$HOME/cuda/nvvm' >> ~/.bashrc
echo 'export CUDA_HOME=$HOME/cuda' >> ~/.bashrc
source ~/.bashrc

# Print confirmation
echo "CUDA environment variables set."

# Verify the CUDA installation
echo "Verifying CUDA installation..."
if command -v nvcc &> /dev/null; then
    nvcc --version
    echo "CUDA 12.4 installation successful!"
else
    echo "CUDA installation failed. Please check your setup."
fi

### INSTALL GPU-ACCELERATED PYTORCH FOR CUDA 12.4 ###

# Install PyTorch with CUDA 12.4 support
echo "Installing PyTorch with GPU support for CUDA 12.4..."
pip install "networkx<3.3" torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu124

# Verify PyTorch installation
echo "Verifying PyTorch installation..."
python3 -c "import torch; print('Torch version:', torch.__version__); print('CUDA available:', torch.cuda.is_available())"

### INSTALL PYTHON LIBRARIES ###

pip install --upgrade pip

pip install --no-cache-dir -r requirements.txt

pip install tokenizers==0.13.0
