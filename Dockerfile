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

RUN apt-get install -y wget

WORKDIR /flo
RUN wget https://files.oip.fun/flo/0.15.0.3/flo-0.15.0-x86_64-linux-gnu.tar.gz
RUN tar xvf flo-0.15.0-x86_64-linux-gnu.tar.gz
RUN cp -R flo-0.15.0/* /usr/local

WORKDIR /root/.flo
ADD flo.conf .

EXPOSE 7312 7313 17312 17313 17413 41289

WORKDIR /ipfs
RUN wget https://dist.ipfs.io/go-ipfs/v0.4.15/go-ipfs_v0.4.15_linux-amd64.tar.gz

RUN tar xvf go-ipfs_v0.4.15_linux-amd64.tar.gz
RUN cp go-ipfs/ipfs /usr/local/bin
RUN ipfs init

WORKDIR /oipdaemon
RUN wget https://files.oip.fun/oipdaemon/oipdaemon.newdb.linux64.tar.gz
RUN tar xvf oipdaemon.newdb.linux64.tar.gz
RUN cp oipdaemonnewdb /usr/local/bin/oipdaemon
RUN chmod a+x /usr/local/bin/oipdaemon
ENV F_URI=127.0.0.1:17313 F_USER=flo F_TOKEN=test1234

WORKDIR /root
COPY start-oip.sh .
CMD ["/root/start-oip.sh"]
