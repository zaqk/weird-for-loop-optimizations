# More optimal for loops
While testing out some for-loop optimizations in Solidity we found a significantly cheaper method. Over 20% cheaper than the most common gas saving for loops method per loop.

In test.sol there are 3 functions with the total gas cost in comments above them:

- **increment0** : The current most popular gas optimized style for loop w/ unchecked increments

- **increment1** : A cheaper more optimized version of increment0

- **increment2** : identical to increment2 but optimized even further using += instead of ++ to save even more gas

## Total gas cost breakdown
### increment0
| loop count | gas cost |
|------------|----------|
| 5    | 22138 |
| 100  | 27743 |
| 1000 | 80855 |

### increment1
| loop count | gas cost |
|------------|----------|
| 5    | 22051 |
| 100  | 26326 |
| 1000 | 66838 |

### increment2
| loop count | gas cost |
|------------|----------|
| 5    | 22019 |
| 100  | 26294 |
| 1000 | 66806 |





## OPCODES


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
