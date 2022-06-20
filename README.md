While testing out some for-loop optimizations in Solidity we found a significantly cheaper method. Over 20% cheaper than the current gas saving meta with 1000 loops.

In test.sol there are 3 functions with the total gas cost in comments above them:

increment0 : The current gas saving meta

increment1 : The new cheaper version of the meta

increment2 : new cheaper version optimized even further using += instead of ++ to save even more gas


UPDATE**
Dug into the opcodes to try and figure out exactly why this is cheaper and I figured it out. Tested increment0 and increment1 to try and figure out where the savings where coming from. Also while doing this i found out that >= is infact cheaper than < because with < or > you need an extra ISZERO opcode. So i refactored increment1 to have a > instead of >= to make the tests more fair

OPCODES for 1 loop with increment0

```
252 JUMPDEST	// 1 gas one time on first loop wont count this in total
253 DUP4	// 3 gas
254 DUP2	// 3 gas
255 LT		// 3 gas
256 ISZERO	// 3 gas
257 PUSH2 0112	// 3 gas
260 JUMPI	// 10 gas
261 DUP1	// 3 gas
262 PUSH1 01	// 3 gas
264 ADD		// 3 gas
265 SWAP1	// 3 gas
266 POP		// 2 gas
267 DUP1	// 3 gas
268 SWAP2	// 3 gas
269 POP		// 2 gas
270 PUSH2 00fc	// 3 gas
273 JUMP	// 8 gas

		// 58 total gas per loop 
```
OPCODES for 1 loop with increment1

```
290 JUMPDEST   //  1 gas one time on first loop wont count this in total
291 DUP1	// 3 gas
292 PUSH1 01	// 3 gas
294 ADD		// 3 gas
295 SWAP1	// 3 gas
296 POP		// 2 gas	
297 DUP1	// 3 gas
298 SWAP2	// 3 gas
299 POP		// 2 gas
300 DUP4	// 3 gas
301 DUP2	// 3 gas
302 GT		// 3 gas
303 ISZERO	// 3 gas
304 PUSH2 0122  // 3 gas
307 JUMPI	// 10 gas

		// 47 gas total per loop
```

EXPLANATION: 
  So when we declare our loop break condition in the for loop, we have check at the beginning of every loop, followed by a JUMPI which is a conditional jump that basically says if this is false jump out of the loop but if its true jump into the loop. And if its true we continue through the loop and then hit the end and have to hit an additonal jump to get back to the top of the loop.
  But in the new way we just continue through the loop and hit our condition at the end and then hit only one JUMPI which says either jump back to the top of the loop or just jump out of the loop. All in all saving us 11 gas a loop, plus possibly some additional gas on the for loop setup
  
  Now for this to work your if statement with the loop break has to be the very last thing in your loop. You have to increment i then check the conditional