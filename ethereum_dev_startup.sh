#!/bin/sh

geth --datadir ~/EtherDev/data --dev --nodiscover    \
  --mine --minerthreads 1 --maxpeers 0 --verbosity 3 \
  --unlock 0 --password ~/EtherDev/etc/passwordfile  \
  --rpc console
