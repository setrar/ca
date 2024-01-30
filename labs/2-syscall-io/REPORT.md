## Luca NEPOTE

## LAB2

In this lab we had to work with software functions that read characters from the keyboard and print them on the console.

Notice also that we used Basic Instructions, Extended (pseudo) instructions, Directives and Syscalls.


In this Lab we should use an application that in a loop:

1. Print a message asking to enter a character.
2. Read a character from the keyboard.
3. Print another message followed by the entered character.
4. Print a good bye message and exit if the entered character was a Q.
5. Else, go back to 1.

Moreover, the structure given in the code complies with the ILP32 ABI (Notice the way we call Syscalls, and how we allocate and de-allocate the stack frame using the stack pointer). 

In the first version of the code, we used only the 'putc' function instead of the 'puti', that prints the character inserted from the keybord. Whereas, in the second part, we added also a 'puti' function that prints the ASCII code of the character.

When we enter a character we save it in the register 's0', then we print the message with the syscall, put the character in 's0' and print it. If the character is not 'Q' the program comes back to main, otherwise it exits printing a 'bye' message. Notice that the program counter (pc) points always to the address of the instruction to be executed.

In order to correctly edit the io.s file, I added a new function puti, copying the putc one and replacing the number of the Syscall from '11' to '1' in order to print the integer in the register 'a0'.
As requested, I also modified the main function to print the integer and not the character, and added a new function "print_ascii_message" in the data segment.
The results obtained for the characters #, u and $ are correct, accordingly to the ASCII table. They are respectively: # = 35, u = 117, $ = 36.

