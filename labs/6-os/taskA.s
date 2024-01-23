.data
counter: .word 0          # Counter variable

.text
.globl taskA

taskA:
    la t0, counter         # Load the address of the counter
    li t1, 10007           # Load the maximum value for the counter
    li t2, 'A'             # Load the ASCII code for 'A'

taskA_loop:
    lw t3, 0(t0)           # Load the current value of the counter
    bge t3, t1, taskA_reset_counter  # If counter >= 10007, reset the counter

    addi  a0,s0,'A'
    jal putc          # Print 'A'

    addi t3, t3, 1          # Increment the counter
    sw t3, 0(t0)           # Store the updated value back to the counter

    j taskA_loop           # Jump to the main loop

taskA_reset_counter:
    li t3, 0               # Reset the counter to 0
    sw t3, 0(t0)           # Store the reset value back to the counter
    j taskA_loop           # Jump back to the main loop

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
#    addi  sp,sp,4     # deallocate stack frame, restore stack pointer
    addi  sp,sp,2     # deallocate stack frame, restore stack pointer
    ret               # return to caller

# Used for testing 
# will be called from os.s
#.globl main

#main:
    # Your setup code goes here, if needed

#    call taskA             # Call the taskA function

    # Your cleanup code goes here, if needed

    # Terminate the program (optional)
#    li a7, 10               # syscall code for Exit
#    ecall
