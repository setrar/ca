init:
        # put value in T0 register with add`i` (immediate)
	addi	t0, zero, 1

shift1:
	## sll (Shift Logical Left Immediate) by one
	slli t1, t0, 1
