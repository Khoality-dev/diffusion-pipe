FROM pytorch/pytorch:2.4.1-cuda11.8-cudnn9-devel AS base
RUN apt-get update && apt-get install -y \
    git \
    wget \
    unzip \
    git-lfs

RUN pip install --upgrade pip
RUN mkdir -p /workspace/diffusion-pipe
WORKDIR /workspace/diffusion-pipe
COPY ./.git /workspace/diffusion-pipe/
RUN git reset --hard -f origin/main
ENV NCCL_P2P_DISABLE=1
ENV NCCL_IB_DISABLE=1
RUN pip install -r requirements.txt
ENTRYPOINT ["/bin/bash"]

FROM base AS hunyuan_video
COPY ./basemodels/clip-vit-large-patch14 /workspace/diffusion-pipe/basemodels/
COPY ./basemodels/llava-llama-3-8b-text-encoder-tokenizer /workspace/diffusion-pipe/basemodels/
COPY ./basemodels/hunyuan_video_FastVideo_720_fp8_e4m3fn.safetensors /workspace/diffusion-pipe/basemodels/
COPY ./basemodels/hunyuan_video_vae_bf16.safetensors /workspace/diffusion-pipe/basemodels/

FROM base AS ltx_video
COPY ./ltx_video /workspace/diffusion-pipe/basemodels