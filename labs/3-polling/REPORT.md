# &#x1F4DD; Report 

---

[TOC]

---

## Assignments

${\color{Salmon}1.}$ In the RARS `Tools` menu select `Keyboard and Display MMIO simulator`.
   A new window appears; click its `Help` button and read the 4 first paragraphs.

  Done &#x2705;

${\color{Salmon}2.}$ Study the code in `mmio.s` and try to understand it.

This code exemplifies basic I/O handling in assembly for scenarios where direct hardware access is required, and it demonstrates polling as a method to synchronize with device readiness without relying on interrupts or operating system services.

${\color{Salmon}3.}$ Load `mmio.s` in RARS and assemble it.

 Done &#x2705;

${\color{Salmon}4.}$ In the `Keyboard and Display MMIO simulator` window click the `Connect to Program` button.
   Execute the `mmio.s` application, enter characters and check your understanding.

<img src=images/mmio-typing.png width='40%' height='40%' > </img>

Lower part of the screen is used for input and upper part for Display

${\color{Salmon}5.}$ Pause the execution (`[Run -> Pause]`).
   In the `Data Segment` sub-window select the `0xffff0000 (MMIO)` region to observe the Receiver and Transmitter registers.
   Enter a character and continue executing step by step.
   Do you understand what happens?

>The MMIO acts like an input output device and allow development access to its memory.
Each time a character is entered, it is stored in a specific address and saved in the `u(t2)` register

   What is the ASCII code of the character you typed?

ASCII: `0` 

   In which register is it stored?

`u(t2)`

${\color{Salmon}6.}$ If you continue executing step by step you should see the sending of the character you typed to the transmitter.
   Then, you should enter the `wait_for_trans_2` loop that waits until the transmitter is ready again to receive a character.
   Instead of stepping until it is, set a breakpoint on the first instruction after the loop and let the execution continue.

 Done &#x2705;

${\color{Salmon}7.}$ After exiting the `wait_for_trans_2` loop, continue step-by-step, observe the printing of the newline character and the branching to the beginning of the program for the next iteration.

 Done &#x2705;

${\color{Salmon}8.}$ Once you are done with your experiments click the `Disconnect from Program` and `Reset` buttons of the `Keyboard and Display MMIO simulator` window.

1. This program could be slightly optimized for speed (number of executed instructions) and footprint (total number of instructions).
   Do you see how?

By removing the duplicated code `wait_for_trans_2`, it will lighten the code 

```diff
-wait_for_trans_2:
-    # initialize CPU registers with addresses of transmitter interface registers
-    li    t0,0xffff0008               # t0 <- 0xffff_0008 (address of transmitter control register)
-    li    t1,0xffff000c               # t1 <- 0xffff_000c (address of transmitter data register)
-    lw    t2,0(t0)                    # t2 <- value of transmitter control register
-    andi  t2,t2,1                     # mask all bits except LSB
-    beq   zero,t2,wait_for_trans_2    # loop if LSB unset (transmitter busy)
-    li    t3,10                       # ASCII code of newline
-    sw    t3,0(t1)                    # send newline character to transmitter
-
```

1. Edit `mmio.s` to implement your optimizations.
   Assemble `mmio.s`, click the `Connect to Program` button of the `Keyboard and Display MMIO simulator` window, test your optimized version. 

Done &#x2705;
