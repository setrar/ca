.global taskB
taskB:
	addi t0, zero, 0  # Initialize variable to 0
	li t1, 30011      # Set loop limit to 30011
	
taskB_loop:
	addi t0, t0, 1          # Increment counter by 1
	bne t0, t1 taskB_loop   # If we are less than the counter limit loop again
	
	li a0, 'B'   # Load charatcer to print in the terminal
	li a7, 11    # Syscall 11 = PrintChar
	ecall        # Print the character
	b taskB      # Loop to start to reset counter