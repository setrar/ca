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

s23:
        # shift register t2 by 23 positions to the left
        slli t2, t2, 23
        
t2pt2:
         add t2, t2, t2
         add t2, t2, t2 # Set breakpoint
         add t2, t2, t2 # Becomes Negative at third iteration
         srli t2, t2, 1
         add t2, t2, t2 # Recovery

tc:
         sub t2, t0, t2 # 2's complement
         
mod128:
    li t3, 1547        # Initialize t3 with the value 1547
    li t4, 127         # Load the value 127 into t4 (0x7F in hexadecimal, 01111111 in binary)
    and t4, t3, t4     # t4 = t3 AND 127, effectively computing t3 mod 128

mod2powern:
    li t3, 260         # Load the number into t3, 260 mod 2^8 should give 4 back
    li t5, 8           # Load modulo value (8) into t5
    li t6, 1
    sll t6, t6, t5     # t6 = 1 << n, shifting 1 left by n bits
    sub t4, t6, t6     # Ensure t4 is zero before subtraction to avoid register misuse
    addi t4, t6, -1    # t4 = 2^n - 1 = (1 << n) - 1
    and t4, t3, t4     # Perform AND operation, t4 = t3 mod 2^n
    
min:
    li t2, -1              # Load -1 into t2
    slli t2, t2, 31        # Shift left by 31 bits, resulting in 0x80000000 in t2

m1:
    addi t2, t2, -1        # Subtract 1 from t2 by adding -1
