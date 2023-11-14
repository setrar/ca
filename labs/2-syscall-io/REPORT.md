### LAB2

## Part1 
Yes, the structure given in the code complies with the ILP32 ABI.

## part4-5

In order to correctly edit the io.s file, I added a new function puti, copying the putc one and replacing the number of the Syscall from 11 to 1 in order to print the integer in the register a0.
As requested, I also modified the main function to print the integer and not the character, and added a new function "print_ascii_message" in the data segment.
The results obtained for the characters #, u and $ are correct, accordingly to the ASCII table.

