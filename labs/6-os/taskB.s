.global taskB
taskB:
	li   s0, 0
	li   s1, 30011
	li   a7, 11
	li   a0, 'B'
taskB_loop:
	beq  s0, s1, taskB_print
	addi s0, s0, 1
	b    taskB_loop
taskB_print:
	ecall
	li   s0, 0
taskB_end:
	b    taskB_loop
