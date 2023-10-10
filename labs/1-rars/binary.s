addi t0, zero, 1
shitf1:
	slli t1, t0, 1
i42:
	addi t2, zero, 42
mul3:
	add t3, t2, t2
	add t2, t2, t3
s23:
	slli t2, t2, 23
t2pt2:
	add t2, t2, t2
	add t2, t2, t2
	srli t2, t2, 1
	add t2, t2, t2
tc:
	addi t2, zero, -100
	slli t2, t2, 1
	srli t2, t2, 1
mod128:
	addi t3, zero, -1547
	srli t4, t3, 7
	slli t4, t4, 7
	sub t4, t3, t4 
min: 
	addi t2, zero, 1
	slli t2, t2, 31
m1: 
	addi t2, t2, -1
rs:
	addi t2, zero, 1
	slli t2, t2, 31
	srai t2, t2, 1