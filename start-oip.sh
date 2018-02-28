#!/bin/bash
if [ ! -d "/root/logs" ]; then
  mkdir /root/logs
fi

export F_URI=127.0.0.1:7313
export F_USER=flo
export F_TOKEN=test1234

ipfs daemon > /root/logs/ipfs.log 2>&1 &
flod -regtest > /root/logs/flod.log 2>&1
sleep 10
flo-cli getinfo > /root/logs/flo-cli.log 2>&1
flo-cli generate 101 >> /root/logs/flo-cli.log
sleep 5
oipdaemon > /root/logs/oipdaemon.log 2>&1
