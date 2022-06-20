# More optimial for loops
While testing out some for-loop optimizations in Solidity we found a significantly cheaper method. Over 20% cheaper than the current gas saving meta with 1000 loops.

In test.sol there are 3 functions with the total gas cost in comments above them:

- **increment0** : The current gas saving meta

- **increment1** : The new cheaper version of the meta

- **increment2** : identical to increment2 but optimized even further using += instead of ++ to save even more gas


## UPDATE
Dug into the opcodes to try and figure out exactly why this is cheaper and I figured it out. Tested increment0 and increment1 to try and figure out where the savings where coming from. Also while doing this i found out that >= is infact cheaper than < because with < or > you need an extra ISZERO opcode. So i refactored increment1 to have a > instead of >= to make the tests more fair


### increment0
### 58 total gas per loop
##### OPCODES for 1 loop with increment0



| OPCODE        | GAS                                                    |
|---------------|--------------------------------------------------------|
| JUMPDEST	| 1 gas, one time cost. wont count this in total.        |
| DUP4. 	| 3 gas							 |
| DUP2	        | 3 gas							 |
| LT		| 3 gas							 |
| ISZERO	| 3 gas							 |
| PUSH2 0112	| 3 gas							 |
| JUMPI		| 10 gas						 |
| DUP1		| 3 gas							 |
| PUSH1 01	| 3 gas							 |
| ADD		| 3 gas							 |
| SWAP1		| 3 gas							 |
| POP		| 2 gas							 |
| DUP1		| 3 gas							 |
| SWAP2		| 3 gas							 |
| POP		| 2 gas							 |
| PUSH2 00fc	| 3 gas							 |
| JUMP		| 8 gas							 | 


### increment1
### 47 gas total per loop
#### OPCODES for 1 loop with increment1


| OPCODE	| GAS							|
|---------------|-------------------------------------------------------|
| JUMPDEST   	| 1 gas, one time on cost. wont count this in total	|
| DUP1		| 3 gas							|
| PUSH1 01	| 3 gas							|
| ADD		| 3 gas							|
| SWAP1		| 3 gas							|
| POP		| 2 gas							|
| DUP1		| 3 gas							|
| SWAP2		| 3 gas							|
| POP		| 2 gas							|
| DUP4		| 3 gas							|
| DUP2		| 3 gas							|
| GT		| 3 gas							|
| ISZERO	| 3 gas							|
| PUSH2 0122    | 3 gas							|
| JUMPI		| 10 gas						|


## EXPLANATION
  So when we declare our loop break condition in the for loop, we have check at the beginning of every loop, followed by a JUMPI which is a conditional jump that basically says if this is false jump out of the loop but if its true jump into the loop. And if its true we continue through the loop and then hit the end and have to hit an additonal jump to get back to the top of the loop.
  But in the new way we just continue through the loop and hit our condition at the end and then hit only one JUMPI which says either jump back to the top of the loop or just jump out of the loop. All in all saving us 11 gas a loop, plus possibly some additional gas on the for loop setup
  
  Now for this to work your if statement with the loop break has to be the very last thing in your loop. You have to increment i then check the conditional
