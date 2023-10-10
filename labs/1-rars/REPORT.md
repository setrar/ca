1. What is the current content of the `pc` register?
0x00400000 As the computer has not started running and is waiting to fetch the first instruction from memory (that address is beginning of program memory)

1. Some other registers are initialized to non-zero values.
   In your terminal use the `s2i` bash function to convert the hexadecimal representation of their content to integer values (type `s2i 0x...`).
0x7fffeffc = 2147479548\

1. Do you understand why all values are positive even when the register content is considered as an integer in sign and magnitude or 2's complement?
The computer does not care the format they are in. Only with instructions we can use the format properly

1. In the help window search the basic instructions that could be used to initialize register `t0` such that `u(t0)` = 1.
addi t0, zero, 1

1. What is the address of the first instruction?
It is always 0x00400000

1. Do you understand why the current content of the `pc` register is the same?
Because it is indicating the address of the instruction to fetch from memory

1. Execute only the first instruction (`[Run -> Step]`) and observe the changes in the registers.
   What registers changed?
   Are these changes consistent with what you imagined?
The t0 and pc registers have changed. As t0 is set to 1 and pc moves onto the next instruction

1. Copy several times the instructions you added after label `t2pt2` such that `t2` can be added to itself several times.
   Assemble, put a breakpoint on the first instruction after `t2pt2`, and execute until the breakpoint.
   Continue the execution step-by-step and observe the evolution of `u(t2)`, `sm(t2)` and `tc(t2)`.
   After how many additions `sm(t2)` and `tc(t2)` become negative?
   This is a first kind of overflow situation: the addition of two positive numbers gives a negative one.
After the second addition, the most significant bit in t2 becomes a 1 changing the number to negative if using signed notations. 0x7E000000 -> 0xFC000000

1. Add `t2` to itself one more time after the sign change.
   Is the new `u(t2)` still correct?
   With this last addition we lost information and we could not recover it.
   This is a second kind of overflow situation: even if considered as unsigned the result of the addition of large unsigned numbers is wrong because it does not fit in 32 bits.
No, because to convert to compliments 2 we need to add 1

1. Imagine a way to discover if, in the RV32IM Instruction Set Architecture, signed numbers are represented in sign and magnitude or in 2's complement.
   Add label `tc` and the corresponding instructions, assemble, execute.
   What do you conclude?
   Why?
We can shift left once to loose the sign and then shift right once. If we are working in sign and magnitude the resulting number should be the same number but in positive. In this case the resulting number has nothing to do with the expected one, so the computer is working in complements 2

1. Would it work with negative numbers?
   Why?
No, because I'm using logical shifting operations which do not take into account the sign of the register.

1. How would you compute the modulo $`2^n`$ with $`1 \le n \le 31`$?
    1. Shift the number to the right by n and store the result in target register (we now have the quotient in target register)
    1. Shift the target register by n to the left and store the result in target register (we now have in target register the number minus the remainder)
    1. Subtract target register to original register and store the result in target register  

1. What is the smallest negative number that can be represented on 32 bits?
   Add label `min` and instructions to store this value in `t2`, assemble, execute and check that `t2` indeed contains the smallest negative number.
sm(0xFFFFFFFF) = -2147483647
tc(0x80000000) = -2147483648

1. Add label `m1` and instructions to subtract 1 from `t2` (add -1).
   Assemble and execute.
   What is the new `tc(t2)`?
   This is another kind of overflow situation: the result of the addition of 2 negative numbers is positive because it does not fit on 32 bits.
The new tc(t2) is 2147483647 which is the same number as before but in positive minus 1

1. Add label `rs` and instructions to store again the smallest negative number in `t2`, and shift it to the right by one position with the `srli` instruction to divide it by 2.
   Assemble and execute.
   What is the new `tc(t2)`?
   Is it half the smallest negative number?
   This is another situation were the numeric result is not the expected one while the computation could be exact (the original number is even) and its result could fit on 32 bits.
New tc(t2) = 1073741824 which is half the original number but in positive

1. Repeat the instructions you added in the previous question but replace `srli` with `srai`.
   Assemble and execute.
   What is the new `tc(t2)`?
   Is it half the smallest negative number?
tc(t2) = -1073741824 which is half the smallest negative number

