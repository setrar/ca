# data section
.data

# text messages
enter_char_message:
.asciz "\nPlease enter a character (Q to quit): "
print_char_message:
.asciz "\nThe character you entered is: "
bye_message:
.asciz "\nBye!"
print_ascii_message:
.asciz "\nThe ASCII code of the character you entered is: "

# code section
.text

# function: getc
# description: read character from keyboard
# parameters: none
# return: ASCII code of read character in a0
# notes: ret is a pseudo-instruction
getc:
    addi  sp,sp,-4    # allocate stack frame (1 register to save = 1*4 = 4 bytes)
    sw    ra,0(sp)    # save ra on stack
    addi  a7,zero,12  # syscall code for ReadChar
    ecall             # call syscall
    lw    ra,0(sp)    # restore ra from stack
    addi  sp,sp,4     # deallocate stack frame, restore stack pointer
    ret               # return to caller

# function: putc
# description: print character to console
# parameters: ASCII code of character to print in a0
# return: none
# notes: ret is a pseudo-instruction
putc:
    addi  sp,sp,-4    # allocate stack frame (1 register to save = 1*4 = 4 bytes)
    sw    ra,0(sp)    # save ra on stack
    addi  a7,zero,11  # syscall code for PrintChar
    ecall             # call syscall
    lw    ra,0(sp)    # restore ra from stack
    addi  sp,sp,4     # deallocate stack frame, restore stack pointer
    ret               # return to caller

# function: puti
# description: print integer in a0 to console
# parameters: integer to print in a0
# return: none
puti:
    addi  sp, sp, -4    # Allocate stack frame
    sw    ra, 0(sp)     # Save ra on stack
    li    a7, 1         # Syscall code for PrintInt
    ecall               # Call syscall
    lw    ra, 0(sp)     # Restore ra from stack
    addi  sp, sp, 4     # Deallocate stack frame
    ret                 # Return to caller

# function: main
# description: read character from keyboard, print it to console, goto end if
#              character is 'Q', else restart from beginning
# parameters: none
# return: none
# notes: la, li, call, mv are pseudo-instructions
.global main
main:
    la    a0,enter_char_message # store address of message in a0
    li    a7,4        # store code of PrintString syscall in a7
    ecall             # call syscall
    call  getc        # call getc function to read character
    mv    s0,a0       # copy read character in s0
    la    a0, print_ascii_message
    li    a7, 4
    ecall
    mv    a0, s0        # Move character ASCII code back into a0
    call  puti          # Print ASCII code of the character
    li    t0,'Q'      # store 'Q' ASCII code in t0
    bne   a0,t0,main  # loop if read character is not 'Q'
    la    a0,bye_message # store address of message in a0
    li    a7,4        # store code of PrintString syscall in a7
    ecall             # call syscall
    li    a7,10       # store code of Exit syscall in a7
    ecall             # call syscall
