.global taskA
taskA:
	li   s0, 0
	li   s1, 10007
	li   a7, 11
	li   a0, 'A'
	# la   s2, taskA   # s2 is also used by os_3.s
taskA_loop:
	beq  s0, s1, taskA_print
	addi s0, s0, 1
	b    taskA_loop
taskA_print:
	ecall
	li   s0, 0   # set the counter to 0
taskA_end:
	b taskA_loop
	# jalr t0, s2, 2
