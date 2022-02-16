FROM raspbian/stretch as build

LABEL maintainer="KD2QAR@gmail.com"

RUN apt-get update;
RUN apt-get install -y libasound2 libasound2-data libbluetooth3 libgps22;

#RUN apt-get install direwolf;

RUN apt-get install -y aptitude
RUN apt-get install -y build-essential gcc gfortran gdb make texinfo 
RUN apt-get install -y git gzip wget curl zip unzip tar vim vim-common vim-runtime 
RUN apt-get install -y ca-certificates 
RUN apt-get install -y sudo cmake libtool vim locate bash-completion

RUN apt-get install -y git gcc g++ make cmake libasound2-dev libudev-dev

WORKDIR /root
RUN git clone https://www.github.com/wb2osz/direwolf
WORKDIR /root/direwolf
RUN git checkout dev
RUN mkdir build
WORKDIR /root/direwolf/build
RUN cmake ..
RUN make -j4
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


