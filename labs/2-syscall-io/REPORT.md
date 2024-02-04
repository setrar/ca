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

### Few Points for ILP32 Compliance:

1. **Register Usage**:
    - The ILP32 ABI specifies that `a0`-`a7` are used for passing arguments to functions and returning values. This part is correctly followed in your code, with `a0` used to pass values and `a7` for system call numbers.
    - `s0`-`s11` are callee-saved registers, meaning if a function uses these registers, it must save and restore their original values. Your code correctly saves and restores the `ra` register but does not modify `s0`-`s11`, so there's no issue here. Using `s0` to temporarily hold a character is fine as long as it's not expected to preserve its value across function calls (which, in this case, it doesn't need to).

2. **Function Call Conventions**:
    - The code correctly uses `call` and `ret` pseudo-instructions for function calls and returns, which is in line with the convention for using the `ra` register to store the return address.
    - The stack frame manipulation (`addi sp, sp, -4` / `addi sp, sp, 4` and saving/restoring `ra` with `sw`/`lw`) is correct and ensures that the `ra` register's value is preserved, which is a requirement for nested function calls.

3. **System Call Conventions**:
    - The use of `a7` for system call numbers and `a0` for system call arguments is correct per the standard system call interface for RISC-V.

4. **Stack Alignment**:
    - The RISC-V ABI requires the stack pointer (`sp`) to be aligned to a 16-byte boundary upon function entry to ensure compatibility with future extensions and external function calls. This code does not explicitly ensure such alignment but modifies the stack pointer in multiples of 4 bytes, which might not suffice if the stack was not already 16-byte aligned at the start of `main`.

5. **Exiting the Program**:
    - Using `li a7, 10` followed by `ecall` for program exit follows the convention for system calls.


${\color{Salmon}3.}$ Assemble `io.s` and simulate.
   After entering (and displaying) several characters reset the simulation (`[Run -> Reset]`) and start executing step-by-step (`[Run -> Step]`).
   After stepping over the `ReadChar` syscall do not forget to enter a character.
   Before each step, try to understand what instruction will be executed and what its effect should be.
   Cross-check your guessing by looking at the content of the registers (including the Program Counter - PC) before and after the step.

   Done &#x2705;

${\color{Salmon}4.}$ Edit `io.s` and modify the code to add a `puti` function that prints the integer in register `a0`.
   Also add a `print_ascii_message` in the `data` segment with value `\nThe ASCII code of the character you entered is: `.
   Modify the `main` function to print `print_ascii_message` instead of `print_char_message`, and to use `puti` instead of `putc` to print the ASCII code of the entered character instead of the character itself.
   Test your modification.

   Done &#x2705;

${\color{Salmon}5.}$ Use your application to find the ASCII codes of characters `#`, `u` and `$`.

<img src=images/syscall-io.png width='50%' height='50%' ></img>
