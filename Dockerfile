FROM node:23.0.0-alpine3.19

ARG N_VERSION

ENV CHROME_BIN="/usr/bin/chromium-browser" \
PUPPETEER_SKIP_CHROMIUM_DOWNLOAD="true" \
CHROME_PATH=/usr/lib/chromium/

WORKDIR /app/domestika

RUN set -x && \
  apk update && \
  apk upgrade && \
  apk add --no-cache \
    ca-certificates \
    curl \
    python3 \
    nss \
    ffmpeg \
    jq \
    mpv \
    aria2 \
    udev \
    ttf-freefont \
    freetype \
    harfbuzz \
    ca-certificates \
    chromium-swiftshader && \
  npm install puppeteer && \
  apk del --no-cache make gcc g++ python3 binutils-gold gnupg libstdc++ && \
  rm -rf /usr/include && \
  rm -rf /var/cache/apk/* /root/.node-gyp /usr/share/man /tmp/*

COPY package*.json ./

RUN \
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
  echo "**** install domestika-downloader ****" && \
  npm i && \
  rm -rf \
    /tmp/*

# Bundle app source
COPY . /app/domestika

RUN export PATH=$PATH:$PWD

CMD [ "npm", "start"]