FROM node:23.0.0-alpine3.19

N_VERSION v0.2.1-beta
ARG N_VERSION

# environment settings
ENV HOME="/app" \
PYTHONIOENCODING=utf-8

COPY . /app/domestika-downloader

RUN \
  echo "**** install packages ****" && \
  apk add  -U --update --no-cache \
    curl \
    nano \
    ffmpeg \
    mpv \
    rar \
    unrar \
    aria2 && \
  echo "**** install m3u8DL ****" && \
  if [ -z ${N_VERSION+x} ]; then \
    N_VERSION=$(curl -s https://api.github.com/repos/nilaoda/N_m3u8DL-RE/releases \
    | jq -r 'first(.[]) | .tag_name'); \
  fi && \
  curl -o \
    /tmp/N_m3u8DL-RE.tar.gz -L \
    "https://github.com/nilaoda/N_m3u8DL-RE/releases/download/${N_VERSION}/N_m3u8DL-RE_Beta_linux-x64_20240828.tar.gz" && \
  tar -xzf \
    /tmp/N_m3u8DL-RE.tar.gz -C \
    /app/domestika --strip-components=1 && \
  cd /app/domestika && \
  chmod +x N_m3u8DL-RE && \
  ech0 "**** install domestika-downloader ****"
  npm install && \
  cp config_template.js config.js && \
  rm -rf \
    /root/.cache \
    /tmp/*
