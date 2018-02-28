FROM ubuntu:artful

RUN apt-get update && apt-get install -y git \
	build-essential libtool autotools-dev automake \
	pkg-config libssl-dev libevent-dev bsdmainutils \
	libboost-system-dev libboost-filesystem-dev \
	libboost-chrono-dev libboost-program-options-dev \
	libboost-test-dev libboost-thread-dev \
	libqt4-dev libprotobuf-dev protobuf-compiler \
	libqrencode-dev libminiupnpc-dev libzmq3-dev \
	software-properties-common && \
	add-apt-repository ppa:bitcoin/bitcoin && apt-get update && \
	apt-get install -y libdb4.8-dev libdb4.8++-dev

RUN git clone https://github.com/oipwg/witseg /flo

WORKDIR /flo

RUN ./autogen.sh && ./configure --without-gui && make && make install

WORKDIR /root/.flo
ADD flo.conf .

EXPOSE 7312 7313 17312 17313 17413 41289

WORKDIR /ipfs
RUN apt-get install -y wget

RUN wget https://ipfs.io/ipns/dist.ipfs.io/go-ipfs/v0.4.13/go-ipfs_v0.4.13_linux-amd64.tar.gz

RUN tar xvf go-ipfs_v0.4.13_linux-amd64.tar.gz
RUN cp go-ipfs/ipfs /usr/local/bin
RUN ipfs init

WORKDIR /oipdaemon
RUN wget https://github.com/dloa/oip-daemon/releases/download/0.4.1/oipdaemon-linux64.tar.gz
RUN tar xvf oipdaemon-linux64.tar.gz
RUN cp oipdaemon /usr/local/bin
ENV F_URI=127.0.0.1:7313 F_USER=flo F_TOKEN=test1234

WORKDIR /root
COPY start-oip.sh .
CMD ["/root/start-oip.sh"]
