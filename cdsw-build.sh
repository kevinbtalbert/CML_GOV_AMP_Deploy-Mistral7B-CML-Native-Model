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

## Shell script needs at least 16GB to successfully execute.

# Create directory for the NVIDIA installer
mkdir -p /home/cdsw/nvidia-installer

# Download the CUDA installer
curl -o /home/cdsw/nvidia-installer/cuda_12.6.3_560.35.05_linux.run https://developer.download.nvidia.com/compute/cuda/12.6.3/local_installers/cuda_12.6.3_560.35.05_linux.run

# Create the directory to install CUDA
mkdir -p ~/cuda

# Run the CUDA installer
bash /home/cdsw/nvidia-installer/cuda_12.6.3_560.35.05_linux.run --no-drm --no-man-page --override --toolkitpath=$HOME/cuda --toolkit --silent

# Set CUDA environment variables (also need to be set in Project Settings if not set via AMP deployment)
export PATH=${PATH}:$HOME/cuda/bin:$HOME/cuda/nvvm
export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:$HOME/cuda/lib64:$HOME/cuda/nvvm/lib64:$HOME/cuda/nvvm
export CUDA_HOME=$HOME/cuda

# Print confirmation
echo "CUDA environment variables set."

# Verify the CUDA installation
echo "Verifying CUDA installation..."
if command -v nvcc &> /dev/null; then
    nvcc --version
    echo "CUDA installation successful!"
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

# Ensure HF_ACCESS_TOKEN is set
if [ -z "$HF_ACCESS_TOKEN" ]; then
  echo "Error: HF_ACCESS_TOKEN environment variable is not set."
  exit 1
fi

# Log in to Hugging Face CLI without user interaction
python -c "from huggingface_hub.hf_api import HfFolder; import os; HfFolder.save_token(os.environ.get('HF_ACCESS_TOKEN'))"