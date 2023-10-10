# Report

## :gear: Install RARS

<img src=images/java-rars.png width='75%' height='75%' > </img>

## :bulb: Number representations

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

## :a: Number representations

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

```assembly
# addition
add t2,t0,t1

# set if less than unsigned unsigned compare between registerrs1 and registerrs2
sltu t3,t2,t0 
```

## 

# References

- [ ] [sm: Sign Magnitude notation](https://www.tutorialspoint.com/sign-magnitude-notation)
- [ ] [Emojis](https://github.com/yodamad/gitlab-emoji)
