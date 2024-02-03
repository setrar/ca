# &#x1F4DD; Report 

---

[TOC]

---

### Launch RARS, settings, help, registers
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

#### Coding

${\color{Salmon}1.}$ In the help window search the basic instructions &#x2705;

${\color{Salmon}2.}$ Insert a label named init &#x2705;

#### Assembling

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

> 0x00400000

${\color{Salmon}3.}$ Do you understand why the current content of the pc register is the same?

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

