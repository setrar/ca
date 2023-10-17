.data
hello: .asciiz "Hello, World!"

.text
.globl _start
_start:
    # Print the string
    la a0, hello
    li a1, 13  # String length
    li a7, 4   # System call for write
    ecall

    # Exit the program
    li a7, 10  # System call for exit
    ecall
