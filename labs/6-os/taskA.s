.global taskA
taskA:
	addi t0, zero, 0  # Initialize variable to 0
	li t1, 10007      # Set loop limit to 10007
	
taskA_loop:
	addi t0, t0, 1          # Increment counter by 1
	bne t0, t1 taskA_loop   # If we are less than the counter limit loop again
	
	li a0, 'A'   # Load charatcer to print in the terminal
	li a7, 11    # Syscall 11 = PrintChar
	ecall        # Print the character
	b taskA      # Loop to start to reset counter