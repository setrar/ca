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
         sub t2, t0, t2 # 2s complement
         
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
    li t2, -1          # Load -1 into t2
    slli t2, t2, 31    # Shift left by 31 bits, resulting in 0x80000000 in t2

m1:
    addi t2, t2, -1    # Subtract 1 from t2 by adding -1
    
rs:
    li t2, 0x80000000  # Load the smallest negative number into t2
    srli t2, t2, 1     # Shift right logically by 1 position
    li t2, 0x80000000  # Load the smallest negative number into t2
    srai t2, t2, 1     # Shift right arithmetic immediate by 1 position
    
uaddsafe:
  # li t0, 0xFFFFFFFF  # Manually set Max to unsigned 32-bit value
  # li t1, 0x1         # Manually add 1 to cause overflow
    add t2, t0, t1     # t2 <- t0 + t1 Perform the addition
    sltu t3, t2, t0    # Set t3 to 1 if t2 < t0 (overflow detection)
    sltu t4, t2, t1    # Set t4 to 1 if t2 < t1 (overflow detection)
    or t3, t3, t4      # If either condition is true, t3 is set to 1


    # Example initialization (These values should be replaced with your test values)

usubsafe:
  # li t0, 0x1         # Manually set a smaller value
  # li t1, 0x2         # Manually set a larger value, causes underflow when subtracted from t0
    sltu t3, t0, t1      # If t0 < t1, then set t3 to 1 (underflow detection)
    sub t2, t0, t1       # Perform the subtraction t0 - t1 and store the result in t2

saddsafe:
  # li t0, 0x7FFFFFFF  # Manually set largest positive 32-bit signed integer
  # li t1, 0x1         # Manually add 1 to cause overflow
    add t2, t0, t1       # Add t0 and t1, result in t2
    
    # Check for overflow
    # Overflow if (t0 > 0 and t1 > 0 and t2 < 0) or (t0 < 0 and t1 < 0 and t2 >= 0)
    slt t4, t0, zero     # t4 = 1 if t0 < 0 else 0
    slt t5, t1, zero     # t5 = 1 if t1 < 0 else 0
    slt t6, t2, zero     # t6 = 1 if t2 < 0 else 0
    xor t4, t4, t5       # t4 = 0 if t0 and t1 have the same sign
    not t4, t4           # Invert t4; t4 = 1 if t0 and t1 have the same sign
    xor t5, t6, t5       # Check if result sign is different from t1s sign
    and t3, t4, t5       # t3 = 1 if overflow occurred

ssubsafe:
  # li t0, 0x80000000  # Manually set smallest 32-bit signed integer
  # li t1, 1           # Manually set by subtracting 1 which should cause overflow
    sub t2, t0, t1         # Perform the signed subtraction t0 - t1
    xor t4, t0, t1         # t4 = 1 (true) if signs of t0 and t1 are different
    xor t5, t0, t2         # t5 = 1 (true) if signs of t0 and result are different
    and t3, t4, t5         # Overflow occurs if t0 and t1 had different signs AND t0 and result have different signs

inv3:
    # Load 1.0 into ft0 (using the immediate representation of 1.0 in floating-point)
    li t0, 0x3F800000  # 1.0 in single-precision floating-point hex representation
    fmv.w.x ft0, t0    # Move the hex representation of 1.0 into the floating-point register ft0
    # Load 3.0 into ft2 (using the immediate representation of 3.0 in floating-point)
    li t1, 0x40400000  # 3.0 in single-precision floating-point hex representation
    fmv.w.x ft2, t1    # Move the hex representation of 3.0 into the floating-point register ft2
    # Compute the inverse of 3 by dividing 1.0 by 3.0
    fdiv.s ft1, ft0, ft2   # ft1 = ft0 / ft2, which computes 1/3

finit:
    # Initialize ft2 to 42
    li t0, 42                # Load 42 into t0
    fcvt.s.w ft2, t0         # Convert and move the integer in t0 to floating-point in ft2

    # Initialize ft3 to 2^30 = 1073741824
    li t1, 1073741824        # Load 2^30 into t1
    fcvt.s.w ft3, t1         # Convert and move the integer in t1 to floating-point in ft3

assoc:
    fsub.s ft5, ft3, ft3   # Subtract ft3 from itself and store the result in ft5 (ft5 = 0)
    fadd.s ft4, ft2, ft5   # Add ft2 and ft5 (which is 42.0), and store the result in ft4 (ft4 = ft2)
    fadd.s ft5, ft2, ft3   # Add ft2 and ft3, store the result in ft5 (temporary storage)
    fsub.s ft5, ft5, ft3   # Subtract ft3 from the result stored in ft5, storing back in ft5


special:
    # Setup for generating +∞: Divide a positive number by 0
    li t0, 0x3F800000  # Load 1.0 (hex representation) into t0
    fmv.w.x ft0, t0    # Move 1.0 into ft0
    li t1, 0           # Load 0 into t1
    fmv.w.x ft1, t1    # Move 0 into ft1
    fdiv.s ft2, ft0, ft1   # ft2 = ft0 / ft1 = 1.0 / 0 = +∞

    # Setup for generating -∞: Divide a negative number by 0
    li t2, 0xBF800000  # Load -1.0 (hex representation) into t2
    fmv.w.x ft3, t2    # Move -1.0 into ft3
    # Reuse ft1 (0) from previous operation
    fdiv.s ft4, ft3, ft1   # ft4 = ft3 / ft1 = -1.0 / 0 = -∞

    # Setup for generating NaN: 0/0 or ∞ - ∞
    fdiv.s ft5, ft1, ft1   # ft5 = ft1 / ft1 = 0 / 0 = NaN
    # Alternatively, subtract +∞ from +∞ for NaN (if needed)
    # fsub.s ft6, ft2, ft2   # ft6 = ft2 - ft2 = ∞ - ∞ = NaN
