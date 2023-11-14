# Ex. 19: Translate from C to RV32IM assembly
# int acc(void) {
#  int i, sum;
#  sum = 0;
#  for (i = 0; i <= 100; i++) {
#      sum += i;
#  }
#  return sum;
# }


acc:
  xor a0, a0, a0         # sum (a0) <- 0
  addi t0, zero, 101     # t0 <- 101
  xor t1, t1, t1         # i (t1) <- 0
acc_loop:
   add a0, a0, t1        # sum <- sum + i
   addi t1, t1, 1        # i <- i + 1
   bne t0, t1, acc_loop  # iterate if not done
   jalr zero, 0(ra)      # return
   
.text
.globl _start
_start:

    # Exit the program
    li a7, 10  # System call for exit
    ecall