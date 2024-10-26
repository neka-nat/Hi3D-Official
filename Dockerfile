FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu22.04

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y tzdata
ENV TZ Asia/Tokyo

RUN apt-get update && apt-get install -y \
    git \
    wget \
    cmake \
    python3-pip \
    libopencv-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace
COPY requirements.txt .

RUN pip3 install --upgrade pip \
    && pip3 install -r requirements.txt \
    && pip install git+https://github.com/facebookresearch/co3d.git \
    && pip install git+https://github.com/openai/CLIP.git

ENV PATH=/usr/local/cuda/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV TCNN_CUDA_ARCHITECTURES=89

RUN pip install git+https://github.com/NVlabs/tiny-cuda-nn/#subdirectory=bindings/torch

COPY . .

CMD ["/bin/bash"]
