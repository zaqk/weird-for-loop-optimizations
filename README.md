While testing out some for-loop optimizations in Solidity we found a significantly cheaper method. Over 20% cheaper than the current gas saving meta with 1000 loops.

In test.sol there are 3 functions with the total gas cost in comments above them:

increment0 : The current gas saving meta

increment1 : The new cheaper version of the meta

increment2 : new cheaper version optimized even further using += instead of ++ to save even more gas
