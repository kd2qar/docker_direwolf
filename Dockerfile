#FROM debian:stretch-slim as build
#FROM debian:buster-slim as build
FROM kd2qar/hamlib AS part1

ENV LD_LIBRARY_PATH=/usr/local/lib

WORKDIR /root

#RUN apt-get update && apt-get -y upgrade && apt-get install -y aptitude && aptitude search libgps && fail

RUN <<-RUNTIMES
	apt-get update && \
	apt-get -y install libasound2 libasound2-data libbluetooth3 libgps28 libudev1 libpthreadpool0 && \
	rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*
	RUNTIMES

FROM part1 AS builder

ADD --keep-git-dir https://github.com/wb2osz/direwolf.git#dev /root/direwolf/

RUN <<-SETUP
	apt-get update  && \
	apt-get install -y libudev-dev build-essential cmake libtool gcc g++ make git libpthreadpool-dev libasound2-dev \
					   vim vim-common vim-runtime ca-certificates bash-completion && \ 
	rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*
	SETUP

RUN <<-SETUP
	cd /root/direwolf && \
	mkdir build && \ 
	cd /root/direwolf/build && \
	cmake .. && \
	make -j4 && \
	make install && \
	make install-conf && \
	make clean && \
	#    rm -rf * && \
	apt-get purge -y build-essential vim vim-common vim-runtime cmake libtool git gcc g++ libasound2-dev libudev-dev ca-certificates libpthreadpool-dev && \
	apt-get -y autoremove && \
	rm -rf /var/lib/apt/lists* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/* 
	SETUP

RUN rm -rf /root/direwolf

FROM scratch

COPY --from=builder / /

LABEL maintainer="KD2QAR@gmail.com"

WORKDIR /srv/direwolf

#COPY * /srv/direwolf/
ADD direwolf.conf /srv/direwolf/
ADD --chmod=755 dwrun /usr/local/bin/dwrun
#COPY * /usr/local/bin/
RUN set

RUN apt-get update; apt-get -y install alsa-utils

ADD --chmod=755 entrypoint.sh /srv/direwolf/entrypoint.sh

#ENTRYPOINT ["direwolf","-p","-dh","-t","1" ]
ENTRYPOINT ["/bin/bash"]


