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
   Add label `mul3` and the corresponding instructions.

${\color{Salmon}4.}$  Assemble but before executing, in the right panel, double-click on the value of `t2` and modify it such that `u(t2)` = 42.
   Execute your code and check that `u(t2)` = 126.

${\color{Salmon}5.}$  To avoid the manual initialization of `t2` each time we execute, just before label `mul3`, insert label `i42` and instructions to initialize `t2` such that `u(t2)` = 42.
   Execute and check that the final value in `t2` is correct.

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

