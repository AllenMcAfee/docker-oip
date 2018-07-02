#!/bin/bash
if [ ! -d "/root/logs" ]; then
  mkdir /root/logs
fi

export F_URI=127.0.0.1:17313
export F_USER=flo
export F_TOKEN=test1234

ipfs daemon > /root/logs/ipfs.log 2>&1 &
flod &
sleep 15

GETBLOCKMSG=`flo-cli getblockchaininfo`
echo $GETBLOCKMSG
while [[ $X = *"Loading block index:"* ]]; do
    sleep 30
    GETBLOCKMSG=`flo-cli getblockchaininfo`
done

oipdaemon -testnet
