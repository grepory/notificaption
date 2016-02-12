FROM node:4.2

# Updating ubuntu packages
RUN apt-get update

# Installing the packages needed to run Nightmare
RUN apt-get install -y \
  xvfb \
  x11-xkb-utils \
  xfonts-100dpi \
  xfonts-75dpi \
  xfonts-scalable \
  xfonts-cyrillic \
  x11-apps \
  clang \
  libdbus-1-dev \
  libgtk2.0-dev \
  libnotify-dev \
  libgnome-keyring-dev \
  libgconf2-dev \
  libasound2-dev \
  libcap-dev \
  libcups2-dev \
  libxtst-dev \
  libxss1 \
  libnss3-dev \
  gcc-multilib \
  g++-multilib \
  musl-dev

# Pull down app environment
RUN mkdir -p /opt/bin && \
    curl -Lo /opt/bin/s3kms https://s3-us-west-2.amazonaws.com/opsee-releases/go/vinz-clortho/s3kms-linux-amd64 && \
    chmod 755 /opt/bin/s3kms

ENV DEBUG 'nightmare'
ENV NODE_ENV 'production'
ENV APPENV 'notificaptionenv'
ENV YELLER_TOKEN ''

# Make sure node_modules aren't installed every time
# http://bitjudo.com/blog/2014/03/13/building-efficient-dockerfiles-node-dot-js/
ADD package.json /tmp/package.json
RUN cd /tmp && npm install
RUN mkdir -p /opt/app && cp -a /tmp/node_modules /opt/app/

# Add current directory to /app
ADD . /app

# Set current working directory as /app
WORKDIR /app

EXPOSE 9099

# Default command. Assumes our file is index.js and our screen size is 1024x768
CMD xvfb-run --server-args="-screen 0 1024x100x24" ./run.sh

