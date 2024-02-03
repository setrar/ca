init:
        # put value in T0 register with add`i` (immediate)
	addi	t0, zero, 1

shift1:
	## slli (Shift Logical Left Immediate) by one
	slli t1, t0, 1

i42:
        # li (load immediate)
        li t2, 0x2a

mul3:
	# Load the value from t1 into t2
	# mv t2, t1

	# Load the value from t2 into a temporary register
	mv t3, t2
        
	# Left shift t3 by 1 to double its value (t3 = 2 * t2)
	slli t3, t3, 1

	# Add t3 to t2 to get 3 * t2
	add t2, t2, t3

