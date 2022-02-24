#FROM debian:stretch-slim as build
FROM debian:buster-slim as build

LABEL maintainer="KD2QAR@gmail.com"


WORKDIR /root

RUN apt-get update  && \
    apt-get install -y libasound2 libasound2-data libbluetooth3 libgps23 && \
    apt-get install -y build-essential  && \
    apt-get install -y vim vim-common vim-runtime && \
    apt-get install -y ca-certificates && \
    apt-get install -y cmake libtool bash-completion && \
    apt-get install -y git gcc g++ make cmake libasound2-dev libudev-dev libasound2 libudev1 && \
    rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/* && \
    git clone https://github.com/wb2osz/direwolf.git && \
    cd /root/direwolf && \
    git checkout dev && \
    mkdir build && \
    cd /root/direwolf/build && \
    cmake .. && \
    make -j4 && \
    make install && \
    make install-conf && \
    make clean && \
    rm -rf * && \
    apt-get purge -y build-essential vim vim-common vim-runtime cmake libtool git gcc g++ libasound2-dev libudev-dev ca-certificates && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/* 

WORKDIR /srv/direwolf

COPY * /srv/direwolf/

COPY * /usr/local/bin/


ENTRYPOINT ["direwolf","-p"]


