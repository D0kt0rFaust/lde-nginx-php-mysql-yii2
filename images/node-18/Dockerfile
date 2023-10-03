FROM node:18

ARG UID=1000
RUN groupmod -g $UID node \
  && usermod -u $UID -g $UID node

USER node
