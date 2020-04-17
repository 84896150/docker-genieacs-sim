FROM node:12-alpine as builder
LABEL MAINTAINER="Michael Hobl <mhobl@vostronet.com>"

RUN apk update && \
    apk add --no-cache \
      git \
      build-base \
      python3

RUN git clone https://github.com/genieacs/genieacs-sim.git /install

WORKDIR /install

RUN npm install

FROM node:12-alpine as main

COPY --from=builder /install /opt/genieacs-sim

WORKDIR /opt/genieacs-sim

RUN apk add --no-cache \
      coreutils

RUN addgroup -S genieacs-sim && adduser -S genieacs-sim -G genieacs-sim \
  && chown -R genieacs-sim:genieacs-sim /opt/genieacs-sim
USER genieacs-sim

ENV ACS_URL="http://127.0.0.1:7547"

ENTRYPOINT [ "sh", "-c", "/opt/genieacs-sim/genieacs-sim -u $ACS_URL -s $RANDOM"]
VOLUME ["/var/log"]