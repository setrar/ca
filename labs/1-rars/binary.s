init:
	addi t0, zero, 1

shift1:
	slli t1, t0, 1

i42:
	addi t2, zero, 42

mul3:
	add  t3, t2, t2
	add  t2, t3, t2

s23:
	slli t2, t2, 23

t2pt2:
	add  t2, t2, t2
	add  t2, t2, t2
	
tc:
	addi t0, zero, -1
	
mod128:
	addi t3, zero, 1547
	slli t4, t3, 25
	srli t4, t4, 25
	
min:
	addi t2, zero, 1
	slli t2, t2, 31

m1:
	addi t2, t2, -1

rs:
	addi t2, zero, 1
	slli t2, t2, 31
	srli t2, t2, 1

rs2:
	addi t2, zero, 1
	slli t2, t2, 31
	srai t2, t2, 1

uaddsafe:
	add  t2, t0, t1
	sltu t3, t2, t0

usubsafe:
	sub  t2, t0, t1
	sltu t3, t0, t1

saddsafe:
	add  t2, t0, t1
	srli t4, t0, 31
	srli t5, t1, 31      # get signs
	mv   t3, zero
	bne t4, t5, saddsafe_over  # If not the same sign, no problems
	slli t4, t0, 1
	slli t5, t1, 1
	# add  t6, t4, t5  # not needed
	sltu t3, t6, t4      # Otherwise, compare like they are unsigned
saddsafe_over:
	# Do nothing

ssubsafe:
	sub  t2, t0, t1
	srli t4, t0, 31
	srli t5, t1, 31
	mv   t3, zero
	beq t4, t5, ssubsafe_over  # If the same sign, no problems
	slli t4, t0, 1
	slli t5, t1, 1
	# sub  t6, t4, t5  # not needed
	sltu t3, t4, t5      # Otherwise, compare like they are unsigned
ssubsafe_over:
	# Do nothing

inv3:
	addi t0, zero, 3
	addi t2, zero, 1
	fcvt.s.w ft0, t0, rne
	fcvt.s.w ft2, t2, rne
	fdiv.s   ft1, ft2, ft0

finit:
	addi t2, zero, 42
	addi t3, zero, 1
	slli t3, t3, 30
	fcvt.s.w ft2, t2, rne
	fcvt.s.w ft3, t3, rne

assoc:
	fsub.s ft4, ft3, ft3, rne
	fadd.s ft4, ft2, ft4, rne

	fadd.s ft5, ft2, ft3, rne
	fsub.s ft5, ft5, ft3, rne

special:
	# Infinity
	addi t6, zero, 2040
	slli t6, t6, 20
	fmv.s.x ft6, t6

	# - Infinity
	addi t0, zero, 2044
	slli t0, t0, 21
	fmv.s.x ft7, t0
	
	# Nan
	addi t0, t0, 1
	fmv.s.x ft0, t0
