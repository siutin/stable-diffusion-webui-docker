FROM debian:bookworm-slim
LABEL maintainer="Martin Chan @osiutino"

ARG BUILD_DATE
ARG BUILD_VERSION

LABEL org.label-schema.build-date=$BUILD_DATE
LABEL org.label-schema.version=$BUILD_VERSION

RUN apt update
RUN apt install -y wget git sudo libgl1 libglib2.0-dev

RUN useradd --home /app -M app -K UID_MIN=10000 -K GID_MIN=10000 -s /bin/bash
RUN mkdir /app
RUN chown app:app -R /app
RUN adduser app sudo
RUN echo 'app ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER app
WORKDIR /app/

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
RUN bash ./Miniconda3-latest-Linux-x86_64.sh -b

RUN git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git /app/stable-diffusion-webui

RUN sed -i -E 's/\+?cu([0-9]{3})//g' /app/stable-diffusion-webui/launch.py
RUN sed -i -E 's/torchvision==([^ ]+)/torchvision/g' /app/stable-diffusion-webui/launch.py

ENV PATH /app/miniconda3/bin/:$PATH

RUN conda install python="3.10" -y

WORKDIR /app/stable-diffusion-webui
RUN  bash ./webui.sh --skip-torch-cuda-test || exit 0