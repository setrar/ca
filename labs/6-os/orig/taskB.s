.data
counterB: .word 0          # Counter for taskB

.text
.globl taskB

taskB:
    la t0, counterB         # Load the address of the counter
    li t1, 30011             # Load the maximum value for the counter
    li t2, 'B'              # Load the ASCII code for 'B'

taskB_loop:
    lw t3, 0(t0)            # Load the current value of the counter
    bge t3, t1, taskB_reset_counter  # If counter >= 5000, reset the counter

    addi  a0,s0,'B'
    jal putc           # Print 'B'

    addi t3, t3, 1           # Increment the counter
    sw t3, 0(t0)            # Store the updated value back to the counter

    j taskB_loop            # Jump to the main loop

taskB_reset_counter:
    li t3, 0                # Reset the counter to 0
    sw t3, 0(t0)            # Store the reset value back to the counter
    j taskB_loop            # Jump back to the main loop

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

# Used for testing 
# will be called from os.s
#.globl main

main:
    # Your setup code goes here, if needed

    call taskB             # Call the taskA function

    # Your cleanup code goes here, if needed

    # Terminate the program (optional)
    li a7, 10               # syscall code for Exit
    ecall
