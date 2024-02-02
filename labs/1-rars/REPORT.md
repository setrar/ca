# Report on 1st lab

## Launch RARS, settings, help, registers

1. The `pc` register currently hold the value `0x00400000`.
2. `sp` has `2147479548`, `gp` has `268468224` while the rest is at zero.
3. The registers are a physical memory place, meaning there can not be a negative memory place (it would be out of the physical place).

## Unsigned and signed integers

### Coding

1. We can use the `addi` instruction like: `addi t0, zero, 1`.

### Assembling

2. The current instruction is on the address `0x00400000`
3. The `pc` register points to the next running instruction. As such, because `0x00400000` is the first free space (and `pc` already had the value in it), the content of `pc` did not change.

### Simulation

1. The only registers that changed is `t0`, its value changed to `0x00000001`.

### Left shifts as a way to multiply by powers of 2

1. `slli t1, t0, 1`
2. The final value stored in t1 is 2.
3. We can use `shift1` and `add`, or 2 `add`.

   ```RISC-V
   mul3-1:
   add t3, t2, t2
   add t3, t3, t2
   mul3-2:
   slli t3, t2, 1
   add t3, t3, t2
   ```

5. `addi t2, zero, 42`

### Overflows

1. `slli t2, t2, 23`. The result is $1056964608 = 126*2^{23}$.
2. `add t2, t2, t2`. The result is 2113929216.
3. After 1 multiplication by 2, we have `u(t2)` = 4227858432, and we have the binary representation being `1111 1100 0000 0000 0000 0000 0000 0000`. Meaning, `sm(t2)` and `tc(t2)` are now negative.
4. We have 4227858432 = 2113929216 * 2
5. After adding one more time, we have `u(t2)` = 4160749568, which is less than 4227858432 and can not be its double.

### Sign and magnitude of 2's complement

1. To discover this, we could use `addi t0, zero, -1`. If RISC-V is using 2's complement, then t0 will be equal to `0xffffffff`, whereas if it is using sign and magnitude, then t0 would be `0xe0000001` (two bits at 1, the first and the last).

### Modulo a power of 2

1. Doing modulo 128 on a number is the same as taking the remainder of the division of this number by 128. To do it, we only need to cut the upper 25 bits of our number, because 2**7 = 128, and 32-7 = 25.
2. It can work for 2's complement but not with sign and magnitude.
3. We can:
   1. Store n in a variable (lets call it `a`),
   2. Shift left the bits while decreasing n until it is equal to zero,
   3. Then we shift right the bits while increasing n until it is equal to `a`.

### Underflow

1. The smallest negative number we can have on 32 bits is $-2^{31}$. The value in `t2` is -2147483648, and it is indeed equal to $-2^{31}$.
2. `tc(t2)` = 2147483647

### Right shifts as a way to divide by powers of 2

1. The new `tc(t2)` is 1073741824. It is equal to $2^{30}$.
2. This time, `tc(t2)` is -1073741824, which is indeed, half of the original `tc(t2)`.

### Controlling overflows

#### uaddsafe

For `uaddsafe`, we use `sltu t3, t2, t0` to know if there was an overflow as `t2` (the sum of `t0` and `t1`) should never be less than `t0` (as we are summing unsigned integer).

#### usubsafe

For `usubsafe`, there will be an overflow if the number we subtract from (`t0`) is less than the number subtracted (`t1`). This is why we use `sltu t3, t0, t1`.

#### ssubsafe

When subtracting two signed numbers (x - y), there are 4 cases:

- x >= 0, y >= 0: never a problem
- x >= 0, y < 0: same problem as if adding two signed numbers
- x < 0, y >= 0: problems
- x < 0, y < 0: no problems

## Floating point numbers

### Understanding the representation of floating point number

2. The floating point binary representation of 1/3 is 0 01111101 0101010101010101010101...
   But as it has to fit on 32 bits, we need to cut it, meaning 1/3 = 0.33333334
3. 1/2 can be represented accurately as we halve the number with each 1 we put in the magnitude. "On the top of my head, 1/2 would be 0 11111111 100000000000000000000000. 0 for sign, 128 for E (so 1), divided by 2 one time."
   Never mind me, forgot the hidden bit. So it is 0 01111110 00000000000000000000000. (Use 2^(-1) rather than trying to get a divided by two in M)

### Floating point instructions

2. The binary representation of 42 is 0 10000100 01010000000000000000000.
   The binary representation of 2^30 is 0 10011101 00000000000000000000000.

### Floating point erasure

2. I think that because we do ft2 + ft3 before subtracting ft3, the difference between ft2 and ft3 is too big for ft3 to change, or said another way, ft2 is too small to impact the representation of ft2 + ft3. Meaning, we have ft2 + ft3 = ft3, and because we subtract ft3, we get 0.

### Floating point special values

We will use the `fmv.s.x` instruction to interpret the bits in a register as a floating point value.
