FROM pytorch/pytorch:2.4.1-cuda11.8-cudnn9-devel

RUN apt-get update && apt-get install -y \
    git \
    wget \
    unzip \
    git-lfs

RUN pip install --upgrade pip
RUN mkdir -p /workspace/diffusion-pipe
WORKDIR /workspace/diffusion-pipe
COPY ./* /workspace/diffusion-pipe/
RUN pip install -r requirements.txt
ENV NCCL_P2P_DISABLE=1
ENV NCCL_IB_DISABLE=1

ENTRYPOINT ["/bin/bash"]