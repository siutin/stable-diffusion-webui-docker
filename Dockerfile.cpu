FROM --platform=$TARGETPLATFORM debian:bookworm-slim
LABEL maintainer="Martin Chan @osiutino"

ARG BUILD_DATE
ARG BUILD_VERSION

LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.version=$BUILD_VERSION

RUN apt update && apt install -y --no-install-recommends \
        bash ca-certificates wget git gcc sudo libgl1 libglib2.0-dev python3-dev google-perftools \
        && rm -rf /var/lib/apt/lists/*

RUN echo "LD_PRELOAD=/usr/lib/libtcmalloc.so.4" | tee -a /etc/environment

RUN useradd --home /app -M app -K UID_MIN=10000 -K GID_MIN=10000 -s /bin/bash
RUN mkdir /app
RUN chown app:app -R /app
RUN usermod -aG sudo app
RUN echo 'app ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER app
WORKDIR /app/

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-$(uname -m).sh
RUN bash ./Miniconda3-latest-Linux-$(uname -m).sh -b \
    && rm -rf ./Miniconda3-latest-Linux-$(uname -m).sh

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git /app/stable-diffusion-webui

ENV PATH /app/miniconda3/bin/:$PATH

RUN conda install python="3.10" -y

WORKDIR /app/stable-diffusion-webui

RUN export TORCH_COMMAND="pip install torch==2.0.0 torchvision==0.15.1" && \
    bash ./webui.sh --skip-torch-cuda-test --use-cpu all --no-download-sd-model 2>&1 | grep "No checkpoints found." || exit 1