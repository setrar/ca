.data
printA: .asciz "A\n"

.text

.global taskA
taskA:
	li t0,0			# set t0 to 0
	li t1,10007		# set t1 to 10007
	
loop_counter:
	addi t0,t0,1		# increase the counter by 1
	beq t0,t1,loop_end 	# branch to end if reached the maximum 
	b loop_counter		# branch to loop_counter 
	
loop_end:
	la a0,printA		# print the character
	li a7,4			# syscall
	ecall			# syscall
	b taskA  		# restart from the beginning 
	
	