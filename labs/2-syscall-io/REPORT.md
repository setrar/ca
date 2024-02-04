# &#x1F4DD; Report 

---

[TOC]

---

## Assignments

The application that we will study in this lab is structured in separate functions.
In order to understand how to write functions in assembly code, the conventions to use, and the role of the _stack_ in all this, first read the following sections of the [FAQ]:

- [How to write functions and call them in assembly code?]
- [What is the ILP32 ABI for the RV32IM ISA?]
- [What are the stack, the stack frames and the stack pointer?]

Our application is a loop that:

1. Print a message asking to enter a character.
1. Read a character from the keyboard.
1. Print another message followed by the entered character.
1. Print a good bye message and exit if the entered character was a `Q`.
1. Else, go back to 1.

In this first version we will use the RARS syscalls to read and print characters and to print messages.

${\color{Salmon}1.}$ Open the `io.s` file with the RARS editor, study the code and try to understand it.
   In order to understand what the various syscalls are doing and how they are called, you will need the `Syscalls` tab of the help window of RARS.

${\color{Salmon}2.}$ Observe how the various functions are written, how they are called, how their input parameters and output results are passed between callers and callees, how the return addresses are handled, how the stack frames are managed and what they are used for.
   Does the code comply with the ILP32 ABI?

${\color{Salmon}3.}$ Assemble `io.s` and simulate.
   After entering (and displaying) several characters reset the simulation (`[Run -> Reset]`) and start executing step-by-step (`[Run -> Step]`).
   After stepping over the `ReadChar` syscall do not forget to enter a character.
   Before each step, try to understand what instruction will be executed and what its effect should be.
   Cross-check your guessing by looking at the content of the registers (including the Program Counter - PC) before and after the step.

${\color{Salmon}4.}$ Edit `io.s` and modify the code to add a `puti` function that prints the integer in register `a0`.
   Also add a `print_ascii_message` in the `data` segment with value `\nThe ASCII code of the character you entered is: `.
   Modify the `main` function to print `print_ascii_message` instead of `print_char_message`, and to use `puti` instead of `putc` to print the ASCII code of the entered character instead of the character itself.
   Test your modification.

${\color{Salmon}5.}$ Use your application to find the ASCII codes of characters `#`, `u` and `$`.

<img src=images/syscall-io.png width='50%' height='50%' ></img>
