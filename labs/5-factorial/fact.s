# compute and return n! = 1*2*3*...*n
# n passed in a0, result returned in a0
factorial:
  addi sp,sp,-8      # allocate 8 bytes stack frame (2 words)
  sw   ra,0(sp)      # save ra in stack frame
  sw   s0,4(sp)      # save s0 in stack frame
  addi s0,zero,3     # s0 <- 3
  bltu a0,s0,end     # go to end if a0 (n) unsigned-less than s0 (3)
  add  s0,zero,a0    # save a0 (n) in s0
  addi a0,a0,-1      # a0 <- a0-1
  jal  ra,factorial  # call factorial, a0 <- factorial(n-1)
  mul  a0,a0,s0      # a0 <- a0*s0 = factorial(n-1)*n
end:
  lw   s0,4(sp)      # restore s0 from stack frame
  lw   ra,0(sp)      # restore ra from stack frame
  addi sp,sp,8       # deallocate stack frame, restore sp
  jalr zero,ra,0     # return to caller, the result is in a0

.global main

main:
  li a0, 5 
  call factorial 
  # li a7, 10
  # ecall
  addi    a0, x0, 0   # Use 0 return code
  addi    a7, x0, 93  # Service command code 93 terminates
  ecall               # Call linux to terminate the program