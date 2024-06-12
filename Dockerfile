# Use the NVIDIA CUDA image as the base image
FROM nvidia/cuda:12.4.0-devel-ubuntu22.04

# Update the package list and install necessary packages
RUN apt-get update && apt-get -y install \
    python3.10 \
    python3-pip \
    openmpi-bin \
    libopenmpi-dev \
    git \
    git-lfs \
    && rm -rf /var/lib/apt/lists/*

# Install the tensorrt_llm package
RUN pip3 install tensorrt_llm -U --pre --extra-index-url https://pypi.nvidia.com

# Create the models directory
RUN mkdir /models

# Copy the locally cloned folders into the container
COPY Meta-Llama-3-8B /app/Meta-Llama-3-8B
COPY TensorRT-LLM /app/TensorRT-LLM

# Set the working directory
WORKDIR /app
RUN pip3 install -r /app/TensorRT-LLM/examples/llama/requirements.txt

# Set the default command
CMD ["bash"]
