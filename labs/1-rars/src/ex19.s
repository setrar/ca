# Ex. 19: Translate from C to RV32IM assembly
# int acc(void) {
#  int i, sum;
#  sum = 0;
#  for (i = 0; i <= 100; i++) {
#      sum += i;
#  }
#  return sum;
# }



# 100 Init
addi t1, zero, 101

# i -> t0 ; sum -> a0
addi a0, zero, 0

# i = 0;
addi t0, zero, 0

# ABI (Application Binary Interface) ra (return address) == x1
# jalr ra, t0, 0

loop:
   add a0, a0, t0
   addi t0, t0, 1
   blt t0, t1, loop
   jalr zero, ra, 0