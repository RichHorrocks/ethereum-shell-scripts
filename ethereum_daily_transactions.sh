#!/bin/sh

# ------------------------------------------------------------------------------
# Find Daily Transactions On The Ethereum Blockchain
# 
# Works on Linux and OS/X. May work on Windows with Cygwin.
#
# Usage:
#   1. Download this script to findDailyTransactions
#   2. `chmod 700 findDailyTransactions`
#   3. Run `geth console` in a window.
#   4. Then run this script `./findDailyTransactions` in a separate window.
#
# History:
#   * Jan 05 2017 - Version 1.0
#
# Enjoy. (c) BokkyPooBah 2016. The MIT licence.
# ------------------------------------------------------------------------------

OUTPUTFILE=findDailyTransactions.out
TSVFILE=findDailyTransactions.tsv
TSVSUMMARY=findDailyTransactionsSummary.tsv

# geth attach << EOF
geth attach << EOF > $OUTPUTFILE

var blocksPerDay = 24 * 60 * 60 / 14;
console.log("Blocks per day: " + blocksPerDay);

// Get extra day
var blocksPerMonth = blocksPerDay * 32;
console.log("Blocks per month: " + blocksPerMonth);

var endBlock = eth.blockNumber;
var startBlock = parseInt(endBlock - blocksPerMonth);

// Testing
// startBlock = parseInt(endBlock - 10);

console.log("Start block: " + startBlock);
console.log("End block: " + endBlock);

var count = {};
var costMap = {};

console.log("Data: Day\tTime\tHash\tGasPrice\tGasUsed\tCost");
for (var i = startBlock; i <= endBlock; i++) {
  var block = eth.getBlock(i, true);
  if (block != null) {
    block.transactions.forEach(function(t) {
      var date = new Date(block.timestamp * 1000);
      var day = date.toJSON().substring(0, 10);
      var time = date.toJSON().substring(11, 19);
      // var key = date.toJSON().substring(11, 16);
      var key = day;
      var tx = eth.getTransaction(t.hash);
      var txR = eth.getTransactionReceipt(t.hash);
      var gasUsed = txR.gasUsed;
      var gasPrice = tx.gasPrice;
      var cost = new BigNumber(gasUsed).mul(gasPrice).div(1e18);
      if (count[key]) {
        count[key]++;
      } else {
        count[key] = 1;
      }
      if (costMap[key]) {
        costMap[key] = costMap[key].plus(cost);
      } else {
        costMap[key] = new BigNumber(cost);
      }
      console.log("Data: " + day + "\t" + time + "\t" + t.hash + "\t" + gasPrice + "\t" + gasUsed + "\t" + cost);
    });
  } 
}

var keys = [];

for (var key in count) {
  keys.push(key);
}

keys.sort();

console.log("Summary: Date\tTxCount\tSumCost");
for (var i = 0; i < keys.length; i++) {
  var key = keys[i];
  var num = count[key];
  var cost = costMap[key];
  console.log("Summary: " + key + " " + num + " " + cost);
}

EOF

grep "Data:" $OUTPUTFILE | sed "s/Data: //" > $TSVFILE
grep "Summary:" $OUTPUTFILE | sed "s/Summary: //" > $TSVSUMMARY
