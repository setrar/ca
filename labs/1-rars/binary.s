init: 
	# The zero register will always be 0. Adding 0 to 1 we can then store 1 into t0
	addi t0, zero, 1
	
shitf1:
	# Use shift logical left with an immediate value
	slli t1, t0, 1

# Multiply by three
i42:
	# Store 42 into register t2
	addi t2, zero, 42
mul3:
	# To multiply by 3 we can add the same value three times
	add t3, t2, t2
	add t2, t2, t3

# Overflows
s23:
	# Shift to the left by 23 positions is the same as multiplying by 2^23
	slli t2, t2, 23
t2pt2:
	# Lets add as many times t2 to itself to see how long it takes to overflow
	add t2, t2, t2
	add t2, t2, t2 # After this instruction, the most significant bit of t2 changes to a 1 changing the number to negative in signed notation
	srli t2, t2, 1 # As we haven't yet overflowed past the most significant bit, we can still recover the previous value by shifting right
	# Let's try to add t2 to itself one more time than before
	add t2, t2, t2
	add t2, t2, t2
	srli t2, t2, 1 # When we try to recover the previous value, the result is not correct as the overflow has passed the most significant bit, and we have lost information

# Sign and magnitude or 2's complement	
tc:
	# One way we can test if numbers are represented in two's compliment is to store a negative number
	# We can shift left once to lose the sign and then shift right once. If we are working in sign and magnitude, the resulting number should be the same number but in positive. In this case the resulting number has nothing to do with the expected one, so the computer is working in compliments 2
	addi t2, zero, -100
	slli t2, t2, 1
	srli t2, t2, 1
	
# Modulo a power of 2
mod128:
	# Store starting number in t3
	addi t3, zero, 1547
	# Shift t3 to the right by 7 (128=2^7) and store the result in t4 (we now have the quotient in t4)
	srli t4, t3, 7
	# Shift t4 by 7 to the left and store the result in t4 (we now have in t4 the number minus the remainder)
	slli t4, t4, 7
	# Subtract t4 to t3 and store the result in t4. The value in t4 is now the modulo  
	sub t4, t3, t4 
	
# Underflow
min: 
	# To get the lowest number possible we can store 1 in t2 and move this bit to the most significant bit, leaving the rest bits to 0
	# This number is the lowest number in two's complement representation
	addi t2, zero, 1
	slli t2, t2, 31
m1: 
	# To get an underflow, we can just subtract 1 to the lowest number possible in t2, which will produce a positive number as a result
	addi t2, t2, -1
	
# Right shifts as a way to divide by powers of 2	
rs:
	# Store the lowest number possible in t2
	addi t2, zero, 1
	slli t2, t2, 31
	# Divide the lowest number possible by 2 using logical shift right
	srli t2, t2, 1 # This instruction produces an incorrect result as it does not take into account the sign of the number
	# If we repeat the same process with arithmetic shift, the result is correct this time, as this kind of shift takes into account the sign
	addi t2, zero, 1
	slli t2, t2, 31
	srai t2, t2, 1
	
# Controlling overflows
uaddsafe:
	# Load register t0 with value 0xffffffff
	addi t0, zero, 0xff
	slli t0, t0, 8
	addi t0, t0, 0xff
	slli t0, t0, 8
	addi t0, t0, 0xff
	slli t0, t0, 8
	addi t0, t0, 0xff
	# Make t1=t0
	add t1, zero, t0
	# Add numbers!
	add t2, t0, t1
	# If the result is less than than t0 or t1 we know it overflowed
	sltu t3, t2, t1
	
usubsafe:
	# Store 1 and 3 in t0 and t1
	addi t0, zero, 0x01
	addi t1, zero, 0x03
	# Subtract!
	sub t2, t0, t1
	# If t0 is less than t1, the resulting number will be negative resulting in overflow
	sltu t3, t0, t1
	
saddsafe:
	# Load register t0 with value 0x80000000 = -2147483648
	addi t0, zero, 0x8
	slli t0, t0, 28
	# Make t1=t0
	add t1, zero, t0
	# Add negative numbers!
	add t2, t0, t1
	# If the result is greater than than t0 and t1 we know it overflowed
	slt t3, t1, t2
	slt t4, t0, t2
	or t3, t3, t4
	
ssubsafe:
	# Load register t0 with value 0x80000000 = -2147483648
	addi t0, zero, 0x8
	slli t0, t0, 28
	# Make t1=t0
	add t1, zero, t0
	# Add negative numbers!
	sub t2, t0, t1
	# If the result is greater than than t0 or t1 we know it overflowed
	slt t3, t1, t2

# Floating point instructions
inv3: 
	# Store 1.0 into t1 using float representation
	addi t1, zero, 0x3F8
	slli t1, t1, 20
	# Move float representation into ft1
	fmv.s.x ft1, t1
	# Store 3 into ft2
	fadd.s ft2, ft1, ft1
	fadd.s ft2, ft2, ft1
	# Compute the inverse of 3
	fdiv.s ft1, ft1, ft2
finit: 
	# Store 0x42280000 into t1 which corresponds to a number of 42.0
	addi t1, zero, 0x42
	slli t1, t1, 8
	addi t1, t1, 0x28
	slli t1, t1, 16
	# Load 42.0 into ft2
	fmv.s.x ft2, t1
	# Store 0x4E800000 into t1 which corresponds to a number of 2^30
	addi t1, zero, 0x4E8
	slli t1, t1, 20
	# Load 2^30 into ft2
	fmv.s.x ft3, t1

# Floating point erasure
assoc:
	# Compute  ft2 + (ft3 - ft3)
	fsub.s ft4, ft3, ft3
	fadd.s ft4, ft4, ft2 # The result is ft2 as (ft3 - ft3) results in 0
	
	# Compute (ft2 + ft3) - ft3
	fadd.s ft4, ft2, ft3
	fsub.s ft4, ft4, ft4 # The result is 0! Because when we compute (ft2 + ft3) we lose the data of ft2 because its magnitude is way lower than ft3 and so we don't have enough bits for representing
	
# Floating point special values
	
infinity:
	# Store 0x7F800000 into t1 which corresponds to +Infinity
	addi t1, zero, 0x7F8
	slli t1, t1, 20
	fmv.s.x ft5, t1
minus_infinity:
	# Store 0xFF800000 into t1 which corresponds to +Infinity
	addi t1, zero, 0xFF
	slli t1, t1, 4
	addi t1, t1, 0x8
	slli t1, t1, 20
	fmv.s.x ft5, t1
nan:
	# Store 0x7F800001 into t1 which corresponds to NaN
	addi t1, zero, 0x7F8
	slli t1, t1, 20
	addi t1, t1, 1
	fmv.s.x ft5, t1
	
	