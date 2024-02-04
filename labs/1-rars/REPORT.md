# &#x1F4DD; Report 

---

[TOC]

---

## Launch RARS, settings, help, registers
---

${\color{Salmon}1.}$ What is the current content of the pc register?

<img src=images/pc_register.png width='25%' height='25%' > </img>

> pc = 0x00400000

${\color{Salmon}2.}$ Some other registers are initialized to non-zero values.
In your terminal use the s2i bash function to convert the hexadecimal representation of their content to integer values (type s2i 0x...).

```bash
 s2i 0x00400000
```
> Returns:
```powershell
U (base 2):   0000 0000 0100 0000 0000 0000 0000 0000 
U (base 10):  4194304
U (base 16):  00400000
SM (base 10): 4194304
TC (base 10): 4194304
```


${\color{Salmon}3.}$ Do you understand why all values are positive even when the register content is considered as an integer in sign and magnitude or 2's complement?

```
s2i 0x80000000
```
> Returns:
```powershell
U (base 2):   1000 0000 0000 0000 0000 0000 0000 0000 
U (base 10):  2147483648
U (base 16):  80000000
SM (base 10): 0
TC (base 10): -2147483648
```

### Unsigned and signed integers
---

### Coding

${\color{Salmon}1.}$ In the help window search the basic instructions &#x2705;

${\color{Salmon}2.}$ Insert a label named init &#x2705;

### Assembling

${\color{Salmon}1.}$ Assemble the code (`[Run -> Assemble]`).
   If there are errors fix them and assemble again until the operation completes successfully.
   The `Execute` tab of the left panel now shows you a detailed view of the portion of the memory that contains the instructions (the _code segment_).
   Each line corresponds to one basic RV32IM instruction:
   - The left column (`Bkpt`) is for breakpoints (back on this later).
   - The `Address` column shows the address in memory of the instruction.
   - The `Code` column shows the instruction encoding in hexadecimal.
   - The `Basic` column shows the human-readable form of the instruction in RV32IM assembly language.
   - The `Source` column shows the source code you wrote with line numbers on the left.

<img src=images/RARS-init.png width='75%' height='75%' > </img>

${\color{Salmon}2.}$ What is the address of the first instruction?

<img src=images/RARS-init-address.png width='25%' height='25%' > </img>

> 0x00400000

${\color{Salmon}3.}$ Do you understand why the current content of the pc register is the same?

Yes, the current content seems to follow the Program Counter's address and derive all other addresses from there.

### Simulation

It's time to test your code step-by-step.

${\color{Salmon}1.}$ Execute only the first instruction (`[Run -> Step]`) and observe the changes in the registers.
   - What registers changed?
The PC has changed incrementing by `x04`
   - Are these changes consistent with what you imagined?
They surely are

${\color{Salmon}2.}$ Predicting next instructions &#x2705;

### Left shifts as a way to multiply by powers of 2

${\color{Salmon}1.}$  Add label `shift1` and instructions to shift `t0` by one position to the left and store the result in register `t1`. &#x2705;

${\color{Salmon}2.}$  Assemble (`[Run -> Assemble]`) and execute your code (`[Run -> Go]`).
   If considered as an unsigned number what is the final value stored in `t1` (use again the `s2i` function if you are not sure)?

> s2i 0x00000002
```powershell
U (base 2):   0000 0000 0000 0000 0000 0000 0000 0010 
U (base 10):  2
U (base 16):  00000002
SM (base 10): 2
TC (base 10): 2
```

${\color{Salmon}3.}$  Imagine a way to multiply by 3 an unsigned number stored in `t2` without using the `mul` instruction.
   Add label `mul3` and the corresponding instructions. &#x2705;

${\color{Salmon}4.}$  Assemble but before executing, in the right panel, double-click on the value of `t2` and modify it such that `u(t2)` = 42.
   Execute your code and check that `u(t2)` = 126. &#x2705;

${\color{Salmon}5.}$  To avoid the manual initialization of `t2` each time we execute, just before label `mul3`, insert label `i42` and instructions to initialize `t2` such that `u(t2)` = 42.
   Execute and check that the final value in `t2` is correct. &#x2705;

> s2i 0x0000007e
```powershell
U (base 2):   0000 0000 0000 0000 0000 0000 0111 1110 
U (base 10):  126
U (base 16):  0000007E
SM (base 10): 126
TC (base 10): 126
```

### Overflows

${\color{Salmon}1.}$ Add label `s23` and instructions to shift register `t2` by 23 positions to the left.

> s2i 0x3f000000
```powershell
U (base 2):   0011 1111 0000 0000 0000 0000 0000 0000 
U (base 10):  1056964608
U (base 16):  3F000000
SM (base 10): 1056964608
TC (base 10): 1056964608
```

${\color{Salmon}2.}$ Add label `t2pt2` and instructions to add `t2` to itself and store the result again in `t2`.
   Assemble, execute and note `u(t2)`.

> s2i 0x7e000000
```powershell
U (base 2):   0111 1110 0000 0000 0000 0000 0000 0000 
U (base 10):  2113929216
U (base 16):  7E000000
SM (base 10): 2113929216
TC (base 10): 2113929216
```

1. Copy several times the instructions you added after label `t2pt2` such that `t2` can be added to itself several times.
   Assemble, put a breakpoint on the first instruction after `t2pt2`, and execute until the breakpoint.
   Continue the execution step-by-step and observe the evolution of `u(t2)`, `sm(t2)` and `tc(t2)`.
   After how many additions `sm(t2)` and `tc(t2)` become negative?

- [x] At the third iteration

<img src=images/becomes-negative.png  width='75%' height='75%' > </img>

   This is a first kind of overflow situation: the addition of two positive numbers gives a negative one.

1. Use `s2i` and note `u(t2)` before and after this sign change.
   Use a calculator to check that the second value, if considered as unsigned, is correct.

- [ ] Before

> s2i 0x7e000000
```powershell
U (base 2):   0111 1110 0000 0000 0000 0000 0000 0000 
U (base 10):  2113929216
U (base 16):  7E000000
SM (base 10): 2113929216
TC (base 10): 2113929216
```

- [ ] After

> s2i 0xfc000000
```powershell
U (base 2):   1111 1100 0000 0000 0000 0000 0000 0000 
U (base 10):  4227858432
U (base 16):  FC000000
SM (base 10): -2080374784
TC (base 10): -67108864
```

   Because it is, we could recover the value before the sign change by shifting `t2` to the right with the `srli` (shift-right-logical) instruction, which is the same as dividing by 2.

- [ ] After `srli`

> s2i 0x7c000000
```powershell
U (base 2):   0111 1100 0000 0000 0000 0000 0000 0000 
U (base 10):  2080374784
U (base 16):  7C000000
SM (base 10): 2080374784
TC (base 10): 2080374784
```

${\color{Salmon}3.}$  Add `t2` to itself one more time after the sign change.
   Is the new `u(t2)` still correct?

> No, it is back to negative

   With this last addition we lost information and we could not recover it.
   This is a second kind of overflow situation: even if considered as unsigned the result of the addition of large unsigned numbers is wrong because it does not fit in 32 bits.

### Sign and magnitude or 2's complement

${\color{Salmon}1.}$  Imagine a way to discover if, in the RV32IM Instruction Set Architecture, signed numbers are represented in sign and magnitude or in 2's complement.
   Add label `tc` and the corresponding instructions, assemble, execute.

```assembly
tc:
         sub t2, t0, t2 # 2's complement   
```

   What do you conclude?

- [ ] Before

> s2i 0xf8000000
```powershell
U (base 2):   1111 1000 0000 0000 0000 0000 0000 0000 
U (base 10):  4160749568
U (base 16):  F8000000
SM (base 10): -2013265920
TC (base 10): -134217728
```

- [ ] After

>  s2i 0x08000001
```powershell
U (base 2):   0000 1000 0000 0000 0000 0000 0000 0001 
U (base 10):  134217729
U (base 16):  08000001
SM (base 10): 134217729
TC (base 10): 134217729
```

   Why?

because only in 2's complement arithmetic does adding a number and its negation yield zero, in our case it adds +1 by converting to positive number

Note: near the bottom of the `Execute` tab of the left panel, a radio button (`Hexadecimal Values`) selects how the content of the registers is displayed.
This is another way to convert their content to numbers but only to hexadecimal or decimal, and only by considering the content as an integer number in 2's complement representation.
For other formats or representations continue using the `s2i` function.

Note: when coding immediate operands in your code you can also use the decimal format (the default) or the hexadecimal (`0x...`) format.

### Modulo a power of 2

${\color{Salmon}1.}$ Imagine a way to compute the modulo 128 of an unsigned number stored in `t3` without the multiplication, division or remainder instructions, and store it in register `t4`.
   Add label `mod128`, instructions to initialize `t3` with 1547, and your instructions.
   Assemble, execute and check that `u(t4)` = 11.

<img src=images/mod128.png  width='25%' height='25%' > </img>

${\color{Salmon}2.}$  Would it work with negative numbers?

   Why?

> No, The direct method using AND with 127 for computing modulo 128 is not suitable for negative numbers when interpreted in a mathematical sense. 

${\color{Salmon}3.}$ How would you compute the modulo $`2^n`$ with $`1 \le n \le 31`$?

```assembly
mod2powern:
    li t3, 260         # Load the number into t3, 260 mod 2^8 should give 4 back
    li t5, 8           # Load modulo value (8) into t5
    li t6, 1
    sll t6, t6, t5     # t6 = 1 << n, shifting 1 left by n bits
    sub t4, t6, t6     # Ensure t4 is zero before subtraction to avoid register misuse
    addi t4, t6, -1    # t4 = 2^n - 1 = (1 << n) - 1
    and t4, t3, t4     # Perform AND operation, t4 = t3 mod 2^n
```

$260 mod 2^8 = 4$

<img src=images/2mod8.png  width='25%' height='25%' > </img>

### Underflow

${\color{Salmon}1.}$ What is the smallest negative number that can be represented on 32 bits?
   Add label `min` and instructions to store this value in `t2`, assemble, execute and check that `t2` indeed contains the smallest negative number.

> s2i 0x80000000
```powershell
U (base 2):   1000 0000 0000 0000 0000 0000 0000 0000 
U (base 10):  2147483648
U (base 16):  80000000
SM (base 10): 0
TC (base 10): -2147483648
```

${\color{Salmon}2.}$  Add label `m1` and instructions to subtract 1 from `t2` (add -1).
   Assemble and execute.
   What is the new `tc(t2)`?

> s2i 0x7fffffff
```powershell
U (base 2):   0111 1111 1111 1111 1111 1111 1111 1111 
U (base 10):  2147483647
U (base 16):  7FFFFFFF
SM (base 10): 2147483647
TC (base 10): 2147483647
```

   This is another kind of overflow situation: the result of the addition of 2 negative numbers is positive because it does not fit on 32 bits.

### Right shifts as a way to divide by powers of 2

${\color{Salmon}1.}$ Add label `rs` and instructions to store again the smallest negative number in `t2`, and shift it to the right by one position with the `srli` instruction to divide it by 2.
   Assemble and execute.
   What is the new `tc(t2)`?

> s2i 0x40000000
```powershell
U (base 2):   0100 0000 0000 0000 0000 0000 0000 0000 
U (base 10):  1073741824
U (base 16):  40000000
SM (base 10): 1073741824
TC (base 10): 1073741824
```

   Is it half the smallest negative number?

> No, it is half of the maximum positive number

   This is another situation were the numeric result is not the expected one while the computation could be exact (the original number is even) and its result could fit on 32 bits.


${\color{Salmon}2.}$ Repeat the instructions you added in the previous question but replace `srli` with `srai`.
   Assemble and execute.
   What is the new `tc(t2)`?

> s2i 0xc0000000
```powershell
U (base 2):   1100 0000 0000 0000 0000 0000 0000 0000 
U (base 10):  3221225472
U (base 16):  C0000000
SM (base 10): -1073741824
TC (base 10): -1073741824
```

   Is it half the smallest negative number?

> Yes, it is

`srli` means Shift-Right-Logical by Immediate shift amount.
The bits entering on the left are zeros.
If we shift a negative number the result thus becomes positive.
`srai` means Shift-Right-Arithmetic by Immediate shift amount.
The bits entering on the left depend on the shifted value: if it is negative they are ones, else zeros.
If we shift a number the result has thus the same sign.
When using right shifts to divide numbers by powers of 2 the instruction to use depends on the numbers: `slli` for unsigned numbers and `srai` for signed numbers.
Note that using `srai` for unsigned numbers would be also wrong because, for instance, `0xffffffff` shifted right by one position with `srai` would give... `0xffffffff`, not the half of `u(0xffffffff)`.

## Controlling overflows

In the first part about integer computations we saw several overflow situations.
Some ISA specify that these situations shall raise exceptions (we will see later in the course what hardware exceptions are and how they are handled).
RV32IM does not raise exceptions on integer overflows.

${\color{Salmon}1.}$  Find a way to compute additions of unsigned numbers and to detect overflows, for instance by setting a second result register to a non-zero value.
   Add label `uaddsafe` and the instructions to safely add the unsigned numbers in `t0` and `t1`, store the result in `t2` and store zero in `t3` if there was no overflow, that is, if `u(t2) = u(t0) + u(t1)`, else store one in `t3`.
   Use as few instructions as possible.
   Assemble, put a breakpoint on the first instruction after label `uaddsafe`, execute, use the register panel to force test values in `t0` and `t1`, continue the execution and check that your safe addition works as expected.

Done &#x2705;

${\color{Salmon}2.}$  Add label `usubsafe` and the instructions to safely subtract the unsigned number in `t1` from the unsigned number in `t0`, store the result in `t2` and store zero in `t3` if there was no overflow, that is, if `u(t2) = u(t0) - u(t1)`, else store one in `t3`.
   Use as few instructions as possible.
   Assemble, and test.

Done &#x2705;

${\color{Salmon}3.}$  Do the same and with additions of signed numbers after label `saddsafe`.

Done &#x2705; Not the best code, too long

${\color{Salmon}4.}$  Do the same and with subtractions of signed numbers after label `ssubsafe`.

Done &#x2705; Not the best code, couldn't make t3 set to 1 but overflows

## Floating point numbers

RARS implements the RV32I ISA, plus extension M (multiplications and divisions), plus extension F (floating point numbers).
As we did with integer numbers we can use the floating point instructions to approximate computations on real numbers.
But here again it is essential to understand how floating point numbers are represented, what limitations this representation has and how to avoid several pitfalls.

Floating point computations do not use the 32 general purpose registers we saw, they use a set of 32 other registers `f0` to `f31`.
Open the `Floating Point` tab of the right panel of RARS to see their current value and their alternate name.
In the following use only the _temporary_ floating point registers named `ft0` to `ft11`, plus the temporary general purpose registers `t0` to `t6` when needed.

### Understanding the representation of floating point number

The IEEE standard number 754-2019 specifies how floating point numbers are represented on 32 bits as follows:

- The leftmost bit (bit number 31) is the sign bit `S`; floating point numbers are represented in sign and magnitude; if `S` = 0 the number is positive, else it is negative.
- Bits 30 down to 23 represent the biased exponent `E` as an unsigned number in range $`[0 \dots 255]`$.
- If `E` is different from 0 and 255, bits 22 down to 0 represent the magnitude `M` as a 24 bits unsigned number with an implicit Most Significant Bit (MSB) equal to one (`M` is in range $`[2^{23} \dots 2^{24} - 1]`$; this is called the _normalized_ representation; the represented value is $`(-1)^S \times 2^{E-127} \times M \times 2^{-23}`$ or, equivalently, $`(-1)^S \times 2^{E-150} \times M`$.
- Else, if `E` is equal to 0, but `M` is not equal to 0, bits 22 down to 0 represent the magnitude `M` as a 23 bits unsigned number (`M` is in range $`[0 \dots 2^{23} - 1]`$; this is called the _denormalized_ representation; the represented value is $`(-1)^S \times 2^{-126} \times M \times 2^{-23}`$ or, equivalently, $`(-1)^S \times 2^{-149} \times M`$.

There are 5 special values:

- If `E` = 0 and `M` = 0, the represented number is +0 or -0, depending on `S`.
  These two values can be used to represent 0.
  They are also a way to represent numbers with a too small magnitude to fit on 32 bits.

- If `E` = 255 and `M` = 0, the represented number is + or - $`\infty`$, depending on `S`.

- If `E` = 255 and `M` is not equal to 0, the value is a NaN (Not-a-Number).
  NaN is a way to represent the result of invalid computations (e.g., the square root of a negative number).
  `M` can be used to provide information about what was wrong (kind of error codes).

${\color{Salmon}1.}$  Open the floating point companion tool of RARS (`[Tools -> Floating Point Representation]`).
   Modify the binary representation to represent successively + and - 0, + and - $`\infty`$, and any NaN.
   After each value change hit the <kbd>Enter</kbd> key to display the floating point value.

| | |
|-|-|
| <img src=images/floating_-0.png  width='' height='' > </img> | <img src=images/floating_0.png  width='' height='' > </img> |
| <img src=images/floating_-Infinity.png  width='' height='' > </img> | <img src=images/floating_Infinity.png  width='' height='' > </img> |
| <img src=images/floating_NaN.png  width='' height='' > </img> | |
 

${\color{Salmon}2.}$   Modify the binary representation to represent as accurately as possible the real number $`1/3`$.
   Note the binary representation you obtained.
   As you can see the floating point representation does not allow the accurate representation of all real numbers, even simple and small rational numbers.

   <img src=images/floating_one-third.png  width='50%' height='50%' > </img>

${\color{Salmon}3.}$   Do you think $`1/2`$ can be represented accurately?
   Why?
   Check with the floating point companion tool.

   <img src=images/floating_one-half.png  width='50%' height='50%' > </img>

 In binary, $\frac{1}{2}$ is `0.1` (just as it is 0.5 in decimal), and this representation fits perfectly within both single and double precision formats without any need for approximation.

### Floating point instructions

The `Basic Instructions` tab of the help window shows all floating point instructions.
Their name starts with a `f` but be careful, some other instructions also start with a `f`.
Most floating point instructions come in two flavors: simple precision (32 bits) and double precision (64 bits).
We are interested in 32 bits floating point computations.
Pick the right ones.
Some instructions require an immediate parameter to specify a rounding mode (the `dyn` sometimes mentioned in the `Basic Instructions` tab of the help window).
We will not explore the different rounding modes, always use `rne` (Round to Nearest, ties to Even).

${\color{Salmon}1.}$ Add label `inv3` at the end of your source file, instructions to initialize `ft0` with value `3`, compute the inverse and store the result in `ft1`.
   Assemble, execute and check that the final content of `ft1` is the same as the one you found with the floating point companion tool.

   <img src=images/floating_one-third_calculation.png  width='25%' height='25%' > </img>

${\color{Salmon}2.}$ Thanks to the variable exponent of the floating point representation we can represent very small and very large numbers.
   Use the companion tool to find the hexadecimal representation of 42, and $`2^{30}`$.
   Add label `finit` and instructions to initialize `ft2` to $`42`$, and `ft3` to $`2^{30} = 1073741824`$ (hint: you can initialize a general purpose register and copy its content as is to a floating point register with instruction `fmv.s.x` or after conversion to a real value with `fcvt.s.w`).
   Assemble, execute and check the content of `ft2` and `ft3` (use the `Hexadecimal Values` radio button to display their content in hexadecimal or in decimal scientific notation).

| | |
|-|-|
| <img src=images/floating_finit-dec.png  width='' height='' > </img> | <img src=images/floating_finit-hex.png  width='' height='' > </img> |

### Floating point erasure

${\color{Salmon}1.}$  Add label `assoc` and instructions to compute `ft2 + (ft3 - ft3)` and store the result in `ft4`, without modifying the content of `ft2` and `ft3`.
   Assemble, execute and check that the result is exactly `ft2`.

Checked, ft2 == ft4 (42.0) &#x2705;

1${\color{Salmon}2.}$  Add instructions to compute `(ft2 + ft3) - ft3` and store the result in `ft5`.
   Assemble, execute and check the result.
   Can you explain what happened?

With the values:
- ft2 = 42.0
- ft3 = 1.07374182E9

I added ft5 <- (ft2 + ft3) : 

```assembly
fadd.s ft5, ft2, ft3
```

ft5 took ft3 value 1.07374182E9 `without adding ft2 value`

```assembly
fsub.s ft5, ft5, ft3   # Subtract ft3 from the result stored in ft5, storing back in ft5
```

Then substracting ft5 (1.07374182E9) by ft3 (1.07374182E9) gave 0.0

Controlling the accuracy of floating point computations is complicated
Among the various aspects that must absolutely be considered there is this surprising fact that the associativity of addition does not hold.
Still, it can also be critical like, for instance, in aerospace or transportation.
Some critical software do not use floating point numbers at all to avoid issues with the computations but this solution is not always possible.

### Floating point special values

1. Write some assembly code implementing floating point computations which final result is +$\infty$, -$\infty$ and NaN.

<img src=images/floating_special.png  width='25%' height='25%' > </img> 

# References

- [ ] [sm: Sign Magnitude notation](https://www.tutorialspoint.com/sign-magnitude-notation)
- [ ] [Emojis](https://github.com/yodamad/gitlab-emoji)

#### :bulb: Number representations

```math
\begin{gather}
\\
[ a_{31}, a_{30}, \dots , a_1, a_0]
\\
{\color{Salmon}u} = \sum_{i=0}^{32} a_i * 2^i \quad \left.\in[ 0, \dots, 2^{32}-1 ]\right|2^{32}
\\
{\color{YellowGreen}sm} = (-1)^{a_{31}} * \sum_{i=0}^{30} a_i * 2^i \quad \left.\in[ -2^{31}+1, \dots, -0, +0, \dots, 2^{31}-1 ]\right|2^{32}-1
\\
{\color{Orange}tc} = -a_{31} * 2^{31} + \sum_{i=0}^{30} a_i * 2^i \quad \left.\in[ -2^{31}, \dots, 0, \dots, 2^{31}-1 ]\right|2^{32}
\end{gather}
```

- [ ] Overflow

```math
\begin{gather}
  a + b = 2^{32} + c \quad ( overflow) \qquad \qquad \\
  \begin{cases}
  a - c = 2^{32} - b > 0  & \quad ( b \in [ 0, \dots, 2^{32}-1 ] ) \\
  and \\
  b - c = 2^{32} - a > 0  & \quad ( a \in [ 0, \dots, 2^{32}-1 ] )
  \end{cases}
  \\
  \begin{cases}
  c < a \\
  c < b
  \end{cases} \qquad \qquad
\end{gather}
```
- [ ] No Overflow

```math
\begin{gather}
  a + b = c \quad \text{ ( no overflow) } \qquad \qquad \\
  \begin{cases}
  c \geq a \\
  c \geq b
  \end{cases}
\end{gather}
```

