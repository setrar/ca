.data
printB: .asciz "B\n"

.text

.global taskB
taskB:
	li t0,0			# set t0 to 0
	li t1,30011		# set t1 to 30011
	
loop_counter:
	addi t0,t0,1		# increase the counter by 1
	beq t0,t1,loop_end 	# branch to end if reached the maximum 
	b loop_counter		# branch to loop_counter 
	
loop_end:
	la a0,printB		# print the character
	li a7,4			# syscall
	ecall			# syscall
	b taskB  		# restart from the beginning 
	