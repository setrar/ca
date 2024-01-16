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

# Function to print a character
putc:
    # Assume that the putc function is provided by the system
    li a7, 11             # syscall code for Print Character
    ecall

# Used for testing 
# will be called from os.s
#.globl main

#main:
    # Your setup code goes here, if needed

#    call taskB             # Call the taskA function

    # Your cleanup code goes here, if needed

    # Terminate the program (optional)
#    li a7, 10               # syscall code for Exit
#    ecall