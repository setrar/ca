### Lab 1: RARS - Efrén BOYARIZO GARGALLO

# Summary
> Overall the lab was very straightforward except for the detecting overflows. I've found many difficulties and most probably my implementations are not perfect:
> 1. `uaddsafe`: if the resulting number is less than any of the two numbers that are being added we can know we have an overflow
> 2. `usubsafe`: as we are subtracting unsigned numbers (u(t0) - u(t1)), if t0 is less than t1, the resulting number will be negative and so we have an overflow
> 3. `saddsafe`: I've used the following formula extracted from a truth table of the signs: $sign(t0)*sign(t1)* \neg sign(t2) + \neg sign(t0)*\neg sign(t1) * sign(t2)$
> 3. `ssubsafe`: We will only have an overflow if: $(t2 < t0) != (t1 > 0)$

# Launch RARS, settings, help, registers
#### 1. What is the current content of the pc register?
> When the computer starts, the pc register will always point to the address 0x00400000. This address corresponds to the beginning of our instruction program memory. If we then proceed to assemble the code, we can see that the first instruction is always located at this address and so when we start the machine the CPU will load this instruction. 

#### 2. Some other registers are initialized to non-zero values. In your terminal use the `s2i` bash function to convert the hexadecimal representation of their content to integer values (type `s2i 0x...`).
> The registers SP and GP are also initialized to non-zero values. Their corresponding decimal values are:
> 
> sp = 0x7fffeffc = 2147479548
> 
> gp = 0x10008000 = 268468224

#### 3. Do you understand why all values are positive even when the register content is considered as an integer in sign and magnitude or 2's complement?
> The computer does not care the format the registers are in. To differentiate between the different format representations we will use different instructions that will apply the desired representation.


# Unsigned and signed integers
## Coding
#### 1. In the help window search the basic instructions that could be used to initialize register `t0` such that `u(t0)` = 1.
> There are different ways we can initialize a register, but the easiest one is to add a register with an immediate value and store the result in t0. Utilizing the zero register, which always has a value of zero, we can then store the immediate value into t0. The instruction is then:
> 
> addi t0, zero, 1

## Assembling
#### 2. What is the address of the first instruction?
> As pointed earlier, the address 0x00400000 corresponds to the address of the first instruction in memory

#### 3. Do you understand why the current content of the `pc` register is the same?
> Because the register pc indicated the address of the instruction to fetch from memory. Which in this case should be the first instruction we just coded

## Simulation
#### 1. Execute only the first instruction (`[Run -> Step]`) and observe the changes in the registers. What registers changed? Are these changes consistent with what you imagined?
> The t0 and pc registers have changed, as t0 is set to 1 and pc moves onto the next instruction at address 0x00400008

## Left shifts as a way to multiply by powers of 2
#### 2. Assemble ([Run -> Assemble]) and execute your code ([Run -> Go]). If considered as an unsigned number what is the final value stored in t1 (use again the s2i function if you are not sure)?
>When shifting to the left is the same as multiplying by 2. Because we are shifting once, the resulting value is 0x00000002=2

#### 3. Imagine a way to multiply by 3 an unsigned number stored in t2 without using the mul instruction. Add label mul3 and the corresponding instructions.
> One simple way of multiplying by three will be to add the value three times

## Overflows
#### 1. Add label s23 and instructions to shift register t2 by 23 positions to the left. Assemble, execute. Use s2i and note the decimal unsigned number corresponding to the current content of t2. Use a calculator to verify that u(t2) =  126×223126 \times 2^{23}126×223. This is what left shifts do to numbers: each shift multiplies by 2, shifting by 23 positions is the same as multiplying by 2232^{23}223. Right shifts do the opposite: divide by a power of 2.
> As expected, the resulting value in t2 is equal to 126*2^23 = 1056964608

#### 2. Add label t2pt2 and instructions to add t2 to itself and store the result again in t2. Assemble, execute and note u(t2). This is another way to multiply a register by 2 without using the mul instruction: add it to itself.
> As we have multiplied by 2, the resulting value is twice the previous one. So t2=2113929216

#### 3. Copy several times the instructions you added after label `t2pt2` such that `t2` can be added to itself several times. Assemble, put a breakpoint on the first instruction after `t2pt2`, and execute until the breakpoint. Continue the execution step-by-step and observe the evolution of `u(t2)`, `sm(t2)` and `tc(t2)`. After how many additions `sm(t2)` and `tc(t2)` become negative? This is a first kind of overflow situation: the addition of two positive numbers gives a negative one.
> After the second addition, the most significant bit in t2 becomes a 1 changing the number to negative if using signed notations. 0x7E000000 -> 0xFC000000

#### 4. Use s2i and note u(t2) before and after this sign change. Use a calculator to check that the second value, if considered as unsigned, is correct. Because it is, we could recover the value before the sign change by shifting t2 to the right with the srli (shift-right-logical) instruction, which is the same as dividing by 2.
> The resulting value in hexadecimal is 0xFC000000 which is equal to 4227858432 in unsigned format. This number is correct as it corresponds to two times the previous one. So we can still recover the value by diving by 2 with shift right

#### 5. Add `t2` to itself one more time after the sign change. Is the new `u(t2)` still correct? With this last addition we lost information and we could not recover it. This is a second kind of overflow situation: even if considered as unsigned, the result of the addition of large unsigned numbers is wrong because it does not fit in 32 bits.
> We have lost information as the last addition's result does no longer fit in the 32 bit register and so information is lost because of the overflow


## Sign and magnitude or 2's complement
#### 1. Imagine a way to discover if, in the RV32IM Instruction Set Architecture, signed numbers are represented in sign and magnitude or in 2's complement. Add label `tc` and the corresponding instructions, assemble, execute. What do you conclude? Why?
> We can shift left once to lose the sign and then shift right once. If we are working in sign and magnitude, the resulting number should be the same number but in positive. In this case the resulting number has nothing to do with the expected one, so the computer is working in complements 2


## Modulo a power of 2
#### 1. Imagine a way to compute the modulo 128 of an unsigned number stored in t3 without the multiplication, division or remainder instructions, and store it in register t4. Add label mod128, instructions to initialize t3 with 1547, and your instructions. Assemble, execute and check that u(t4) = 11.
>    1. Shift t3 to the right by 7 (128=2^7) and store the result in t4 (we now have the quotient in t4)
>
>    2. Shift t4 by 7 to the left and store the result in t4 (we now have in t4 the number minus the remainder)
>
>    3. Subtract t4 to t3 and store the result in t4. The value in t4 is now the modulo  
   
#### 2. Would it work with negative numbers? Why?
> No, because I'm using logical shifting operations which do not take into account the sign of the register.

#### 1. How would you compute the modulo $`2^n`$ with $`1 \le n \le 31`$?
> 1. Shift the number to the right by n and store the result in target register (we now have the quotient in target register)
> 
> 2. Shift the target register by n to the left and store the result in target register (we now have in target register the number minus the remainder)
> 
> 3. Subtract target register to original register and store the result in target register  


## Underflow
#### 1. What is the smallest negative number that can be represented on 32 bits? Add label `min` and instructions to store this value in `t2`, assemble, execute and check that `t2` indeed contains the smallest negative number.
> The smallest possible numbers depend on the number representation. For signed notation and two's compliment:
> 
> sm(0xFFFFFFFF) = -2147483647
> 
> tc(0x80000000) = -2147483648
> 
> To get the lowest number, we can store a 1 in the least significant bit and move in by shifting left to the most significant bit. This will leave our register with a 1 followed by all 0s, which corresponds to the lowest number possible in two's compliment

#### 2. Add label `m1` and instructions to subtract 1 from `t2` (add -1). Assemble and execute. What is the new `tc(t2)`? This is another kind of overflow situation: the result of the addition of 2 negative numbers is positive because it does not fit on 32 bits.
> The new tc(t2) is 2147483647 which is the same number as before but in positive minus 1


## Right shifts as a way to divide by powers of 2
#### 1. Add label `rs` and instructions to store again the smallest negative number in `t2`, and shift it to the right by one position with the `srli` instruction to divide it by 2. Assemble and execute. What is the new `tc(t2)`? Is it half the smallest negative number? This is another situation were the numeric result is not the expected one while the computation could be exact (the original number is even) and its result could fit on 32 bits.
> New tc(t2) = 1073741824 which is half the original number but in positive

#### 1. Repeat the instructions you added in the previous question but replace `srli` with `srai`. Assemble and execute. What is the new `tc(t2)`? Is it half the smallest negative number?
> tc(t2) = -1073741824 which is half the smallest negative number


# Controlling overflows
#### 1. Find a way to compute additions of unsigned numbers and to detect overflows, for instance by setting a second result register to a non-zero value. Add label uaddsafe and the instructions to safely add the unsigned numbers in t0 and t1, store the result in t2 and store zero in t3 if there was no overflow, that is, if u(t2) = u(t0) + u(t1), else store one in t3. Use as few instructions as possible. Assemble, put a breakpoint on the first instruction after label uaddsafe, execute, use the register panel to force test values in t0 and t1, continue the execution and check that your safe addition works as expected.
> The simplest way to detect overflows is to compare the resulting number to any of the two addend. If the resulting number is less, we can conclude that an overflow occurred. To accomplish this, we can use the instruction `sltu t3, t2, t1` which will store a 1 in t3 if t2 is lower than t1

#### 2. Add label usubsafe and the instructions to safely subtract the unsigned number in t1 from the unsigned number in t0, store the result in t2 and store zero in t3 if there was no overflow, that is, if u(t2) = u(t0) - u(t1), else store one in t3. Use as few instructions as possible. Assemble, and test.
> In a subtraction, we can know with certainty that an overflow will occur if t1 is bigger than t0. As such, the simplest way to detect an overflow is to use `sltu t3, t0, t1` which will set t3 to 1 if t0 is lower than t1

#### 3. Do the same and with additions of signed numbers after label `saddsafe`.
> If both numbers are negative we can use the same methodology. If the result is greater that any of the two numbers we know it overflowed. We can use slt instruction for comparisson between negative numbers:
>
> slt t3, t1, t2

#### 4. Do the same and with subtractions of signed numbers after label `ssubsafe`.
> If both numbers are negative we can use the same methodology. If the result is greater that any of the two numbers we know it overflowed. We can use slt instruction for comparisson between negative numbers:
> 
> slt t3, t1, t2

# Floating point numbers
## Understanding the representation of floating point number
#### 2. Modify the binary representation to represent as accurately as possible the real number $`1/3`$. Note the binary representation you obtained. As you can see the floating point representation does not allow the accurate representation of all real numbers, even simple and small rational numbers.
> 0 01111101 01010101010101010101011 = 0.33333334

#### 3. Do you think $`1/2`$ can be represented accurately? Why? Check with the floating point companion tool.
> Yes, as it can be represented by 2^(-1) which is a power of 2
> 
> With the tool, the number obtained is 0 01111110 00000000000000000000000 = 0.5

## Floating point instructions
#### 1. Add label inv3 at the end of your source file, instructions to initialize ft0 with value 3, compute the inverse and store the result in ft1. Assemble, execute and check that the final content of ft1 is the same as the one you found with the floating point companion tool.
> To compute the inverse we can store into a normal register the representation of 1.0. Move this representation into ft1 and add its value three times to store it into ft2. The inverse of 3 can then be calculated by the division of ft1/ft2 which equals as expected 0.33333334
> 
> This number corresponds to the one obtained in the companion tool as it is the closest we can get to 1/3 with float precission

#### 2. Thanks to the variable exponent of the floating point representation we can represent very small and very large numbers. Use the companion tool to find the hexadecimal representation of 42, and 2302^{30}230. Add label finit and instructions to initialize ft2 to 424242, and ft3 to 230=10737418242^{30} = 1073741824230=1073741824 (hint: you can initialize a general purpose register and copy its content as is to a floating point register with instruction fmv.s.x or after conversion to a real value with fcvt.s.w). Assemble, execute and check the content of ft2 and ft3 (use the Hexadecimal Values radio button to display their content in hexadecimal or in decimal scientific notation).
> Using the method described of loading the representation first into a normal register, the obtained values are the ones expected:
> 
> ft2 = 0x42280000 = 42.0
>
> ft3 = 0x4e800000 = 1.07374182E9

## Floating point erasure
#### 1. Add label assoc and instructions to compute ft2 + (ft3 - ft3) and store the result in ft4, without modifying the content of ft2 and ft3. Assemble, execute and check that the result is exactly ft2.
> The result is ft2 as the previous operation (ft3 - ft3) results in 0 (both numbers have the same magnitude so no information is lost)

#### 2. Add instructions to compute (ft2 + ft3) - ft3 and store the result in ft5. Assemble, execute and check the result. Can you explain what happened?
> The result is 0. This can be explained as when we compute (ft2 + ft3) we lose the data of ft2 because its magnitude is way lower than ft3 and so we don't have enough bits for representing that many decimal places

## Floating point special values
#### 1. Write some assembly code implementing floating point computations which final result is +$\infty,−, -,−\infty$ and NaN
> +Infinity corresponds to S=0 E=255 M=0 => 0x7F800000
>
> -Infinity corresponds to S=1 E=255 M=0 => 0xFF800000
>
>  NaN corresponds to S=0 E=255 M=1 => 0x7F800001 