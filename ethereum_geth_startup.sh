#!/bin/sh

# Graceful exit, like pressing Control-C on a program
killall -q --signal SIGINT geth
sleep 10

# Hard kill, only to stop a process that refuses to terminate
killall -q geth

# Clear IPC as this can sometimes cause problems
rm -f /home/user/.ethereum/geth.ipc

DATE=`date +%Y%m%d_%H%M%S`
mv /home/user/ethlogs/geth.log /home/user/logarchive/geth.log_$DATE

# Message <= 32 bytes
MESSAGE="BokkyPooBah wuz here!"

# Use 6 for full details
VERBOSITY=3

geth --support-dao-fork --rpc --rpcaddr "192.168.7.123" --rpcport 8545 --extradata "$MESSAGE" --verbosity $VERBOSITY 2>> /home/user/ethlogs/geth.log &
