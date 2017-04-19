#!/bin/bash
# ------------------------------------------------------------------------------
# Check account balance
#
# Works on Linux and OS/X. May work on Windows with Cygwin.
#
# Usage:
#   1. Download this script to checkBalance
#   2. `chmod 700 checkBalance`
#   3. Run `geth console` in a window.
#   4. Then run this script `./checkBalance` in a separate window.
#
# Parameters:
#   account    Account to check the balance. Defaults to GOLEM multisig
#   block      Blocknumber. Defaults to "latest"
#
# Sample Usage:
#   ./checkBalance
#   '0x7da82c7ab4771ff031b66538d2fb9b0b047f6cf9' at 'latest' has 770001.899999999999999999 ETH
#   ./checkBalance 0x7da82c7ab4771ff031b66538d2fb9b0b047f6cf9 2691189
#   '0x7da82c7ab4771ff031b66538d2fb9b0b047f6cf9' at '2691189' has 820002.9 ETH
#
# History:
#   * Jan 07 2017 - Version 1.0
#
# Enjoy. (c) BokkyPooBah 2016. The MIT licence.
# ------------------------------------------------------------------------------

# Leave ATTACHPARAMETER as undefined normally
# RPC
# ATTACHPARAMETER="rpc:http://localhost:8545"
# OS/X IPC
# ATTACHPARAMETER="ipc:$HOME/Library/Ethereum/geth.ipc"

# Golem multisig
ACCOUNT=${1:-"0x7da82c7ab4771ff031b66538d2fb9b0b047f6cf9"}
BLOCK=${2:-"latest"}

# echo "ACCOUNT: $ACCOUNT"
# echo "ATTACHPARAMETER: $ATTACHPARAMETER"

# Uncomment the following line and comment the next line using // while debugging this script
# geth attach $ATTACHPARAMETER << EOF
geth attach $ATTACHPARAMETER << EOF | grep "Data: " | sed "s/Data: //"

var balance=web3.fromWei(eth.getBalance("$ACCOUNT", "$BLOCK"), "ether");
console.log("Data: '$ACCOUNT' at '$BLOCK' has " + balance + " ETH");

EOF
