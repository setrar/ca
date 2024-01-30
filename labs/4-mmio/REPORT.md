## Luca NEPOTE

## Lab4 

In this lab we want to combine what we have done in the previous two labs.
At first we copy the `io.s` file and we edited it in order to come back to the original version.
As requested, we changed the function in order to print the character message instead of the ASCII code. Moreover, we changed the "getc" function in order to use memory mapped I/O and polling instead of syscalls.
Following the instructions given in the lab assignment, we tested the correctness of the code.
We then replaced all the syscalls with the function written by ourselves, in order to print the string and the result on the MMIO simulator: to do that we use a loop to print each character one by one till we reach the NUL character, as suggested by the assignment.

We added a new function called "d2i", that has to take the ASCII code of a digit and transforms it in the digital number. If the character inserted is not a number, we set the register "a1" to `1`, otherwise it is equal to `0`.
After that, we changed the code in order to use a "geti" function to take multiple digits integer instead of using the "ReadInt" syscall. For this, we managed also the case in which the number cannot be represented in 32 bits, using another value error for "a2" equal to `2`.

In order to print the number written with the keyboard, we use a recursion loop of the function "puti". In this way we can print each digit in the correct order. We replaced the "PrintInt" syscall with our solution.

We finally modified the code as requested, able to take a multi digit number as input and representing it in the MMIO simulator.
The program works correctly, able to recognize the different kind of errors, such as the the not a digit one and the overflow. 


