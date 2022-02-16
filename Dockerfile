FROM debian:stretch-slim as build

LABEL maintainer="KD2QAR@gmail.com"

RUN apt-get update  && \
    apt-get install -y libasound2 libasound2-data libbluetooth3 libgps22 && \
    apt-get install -y build-essential  && \
    apt-get install -y vim vim-common vim-runtime && \
    apt-get install -y ca-certificates && \
    apt-get install -y cmake libtool bash-completion && \
    apt-get install -y git gcc g++ make cmake libasound2-dev libudev-dev && \
    rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*;

WORKDIR /root
RUN git clone https://www.github.com/wb2osz/direwolf
WORKDIR /root/direwolf
RUN git checkout dev
RUN mkdir build
WORKDIR /root/direwolf/build
RUN cmake ..
RUN make -j4

#FROM debian:stretch-slim
WORKDIR /root
#COPY --from=build /root/direwolf /root/direwolf

#RUN apt-get update; 

WORKDIR /root/direwolf/build

#RUN apt-get install -y make cmake &&  \
#    rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*;

RUN make install
RUN make install-conf



#RUN apt-get update && \
#    apt-get -y install libasound2 alsa-utils pulseaudio && \
#    apt-get -y autoremove && \
#    apt-get purge && apt-get clean && \
#    rm -rf /var/lib/apt/lists/* && \
#    rm -rf /tmp/* /var/tmp/*  && \
#    rm -rf /usr/share/doc/* && \
#    rm -rf /usr/share/man/* ;
#RUN arecord -l

WORKDIR /srv/direwolf

COPY * /srv/direwolf/

COPY * /usr/local/bin/


ENTRYPOINT ["dwrun"]


