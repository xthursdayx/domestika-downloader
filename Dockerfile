FROM node:23.0.0-alpine3.19

ARG N_VERSION

# environment settings
ENV HOME="/app" \
PYTHONIOENCODING=utf-8

WORKDIR /app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN \
  echo "**** install packages ****" && \
  apk add  -U --update --no-cache \
    curl \
    nano \
    ffmpeg \
    jq \
    mpv \
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
    /app --strip-components=1 && \
  cd /app && \
  chmod +x N_m3u8DL-RE && \
  echo "**** install domestika-downloader ****" && \
  npm install && \
  rm -rf \
    /root/.cache \
    /tmp/*

# Bundle app source
COPY . .

CMD [ "npm", "start"]