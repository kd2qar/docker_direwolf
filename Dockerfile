#FROM debian:stretch-slim as build
#FROM debian:buster-slim as build
FROM kd2qar/hamlib

LABEL maintainer="KD2QAR@gmail.com"

ENV LD_LIBRARY_PATH=/usr/local/lib

WORKDIR /root

#RUN apt-get update && apt-get -y upgrade && apt-get install -y aptitude && aptitude search libgps && fail

RUN apt-get update  && \
    apt-get install -y libasound2 libasound2-data libbluetooth3 libgps28 && \
    apt-get install -y build-essential  && \
    apt-get install -y vim vim-common vim-runtime && \
    apt-get install -y ca-certificates && \
    apt-get install -y cmake libtool bash-completion && \ 
    apt-get install -y git gcc g++ make cmake libasound2-dev libudev-dev libasound2 libudev1 && \
    rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/* && \
    git clone https://github.com/wb2osz/direwolf.git  && \
    cd /root/direwolf && \
    git checkout dev && \
    mkdir build && \
    cd /root/direwolf/build && \
    cmake .. && \
    make -j4 && \
    make install && \
    make install-conf && \
    make clean && \
#    rm -rf * && \
    apt-get purge -y build-essential vim vim-common vim-runtime cmake libtool git gcc g++ libasound2-dev libudev-dev ca-certificates && \
    apt-get -y autoremove && \
    rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/* 

WORKDIR /srv/direwolf

#COPY * /srv/direwolf/
COPY direwolf.conf /srv/direwolf/

COPY * /usr/local/bin/
RUN set

#ENTRYPOINT ["direwolf","-p","-dh","-t","1" ]
ENTRYPOINT ["/bin/bash"]


