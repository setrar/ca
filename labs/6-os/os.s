.data

# messages to print for implemented exceptions
_m1: .asciz "\nException "
_m2: .asciz " occurred\n"
_m3: .asciz "Unrecoverable, aborting\n"
_e0: .asciz " (instruction address misaligned)"
_e1: .asciz " (instruction access fault)"
_e2: .asciz " (illegal instruction)"
_e3: .asciz " (breakpoint)"
_e4: .asciz " (load address misaligned)"
_e5: .asciz " (load access fault)"
_e6: .asciz " (store address misaligned)"
_e7: .asciz " (store access fault)"
_e8: .asciz " (environment call)"
# _excp is the base address of an array of message addresses:
# address of message for exception number N is at _excp + 4 * N
_excp: .word _e0, _e1, _e2, _e3, _e4, _e5, _e6, _e7, _e8

# implemented interrupts (not standard compliant!)
# 0: reserved
# 1: reserved
# 2: reserved
# 3: reserved
# 4: timer (timer tool)
# 5: reserved
# 6: keyboard (keyboard and display simulator tool)
# 7: display (keyboard and display simulator tool)
# 8: timer (digital lab sim tool)
# 9: hexadecimal keyboard (digital lab sim tool)
# _isrs is the base address of an array of Interrupt Service Routine (ISR) addresses:
# address of ISR for interrupt number N is at _isrs + 4 * N
_isrs: .word _isr0, _isr1, _isr2, _isr3, _isr4, _isr5, _isr6, _isr7, _isr8, _isr9

# kernel stack
kstack: .space 1024

.text

exception_handler:
# save sp in uscratch, set sp to kernel stack base address, save t0, t1, a0 and
# a7 in kernel stack
  csrrw  zero,uscratch,sp      # save sp in uscratch
  la     sp,kstack             # sp <- base address of kernel stack
  sw     t0,0(sp)              # kstack[0] <- t0
  sw     t1,4(sp)              # kstack[4] <- t1
  sw     a0,8(sp)              # kstack[8] <- a0
  sw     a7,12(sp)             # kstack[12] <- a7

# get cause of interrupt / exception
  csrrsi t0,ucause,0           # t0 <- ucause (code of exception)
  blt    t0,zero,interrupts    # if interrupt goto interrupts

# print information about exception
  li     a7,4                  # a7 <- code of PrintString syscall
  la     a0,_m1                # a0 <- address of _m1 message
  ecall                        # syscall
  li     a7,1                  # a7 <- code of PrintInt syscall
  mv     a0,t0                 # a0 <- t0 (exception code)
  ecall                        # syscall
  li     a7,4                  # a7 <- code of PrintString syscall
  slli   t1,t0,2               # t1 <- 4 * t0 (4 * exception code)
  la     a0,_excp              # a0 <- address of _excp
  add    a0,a0,t1              # a0 <- a0 + t1
  lw     a0,0(a0)              # a0 <- address of exception message
  ecall                        # syscall
  la     a0,_m2                # a0 <- address of _m2 message
  ecall                        # syscall

# if exception is breakpoint or environment call skip causing instruction and
# return
  li     t1,3                  # t1 <- code of breakpoint exception
  beq    t0,t1,skip            # if breakpoint goto skip
  li     t1,8                  # t1 <- code of environment call exception
  beq    t0,t1,skip            # if environment call goto skip

# else print abort message and terminate
  li     a7,4                  # a7 <- code of PrintString syscall
  la     a0,_m3                # a0 <- address of _m3 message
  ecall                        # syscall
  li     a7,10                 # a7 <- code of Exit syscall
  ecall                        # syscall

# interrupt dispatcher
interrupts:

  slli   t1,t0,2               # t1 <- 4 * t0 (4 * interrupt code)
  la     a0,_isrs              # a0 <- base address of _isrs
  add    a0,a0,t1              # a0 <- a0 + t1
  lw     a0,0(a0)              # a0 <- address of ISR
  jalr   zero,0(a0)            # jump at ISR
  
# ISRs: interrupt-specific code goes here
# reserved
_isr0:
  b      ret

# reserved
_isr1:
  b      ret

# reserved
_isr2:
  b      ret

# reserved
_isr3: 
  b      ret

# timer
_isr4:
  b      ret

# reserved
_isr5:
  b      ret

# keyboard (keyboard and display simulator tool)
_isr6:
  b      ret

# display (keyboard and display simulator tool)
_isr7:
  b      ret

# timer (digital lab sim tool)
_isr8:
  b      ret

# hexadecimal keyboard (digital lab sim tool)
_isr9:
  b      ret

# return from (non-interrupt) exception, skip offending instruction at uepc to
# avoid infinite loop
skip:
  csrrsi t0,uepc,0             # t0 <- uepc
  addi   t0,t0,4               # skip causing instruction
  csrrw  zero,uepc,t0          # uepc <- t0

# restore cpu registers t0, t1, a0 and a7 from kernel stack, sp from uscratch,
# and return
ret:
  lw     t0,0(sp)              # t0 <- kstack[0]
  lw     t1,4(sp)              # t1 <- kstack[4]
  lw     a0,8(sp)              # a0 <- kstack[8]
  lw     a7,12(sp)             # a7 <- kstack[12]
  csrrw  sp,uscratch,zero      # restore sp from uscratch
  uret                         # return from exception handler

.data

hw: .asciz "\nHello, World!\n"

.text

# standard startup and termination code
# should probably be named "_start" or something similar but RARS only
# supports initialization of PC to global symbol named "main". So we
# use "main" instead of "_start".
.global main
main:
# initialize utvec with address of exception handler
  la     t0,exception_handler  # t0 <- address of exception handler
  csrrw  zero,utvec,t0         # initialize utvec CSR with address of exception handler

# globally enable interrupts
  csrrsi zero,ustatus,1

# print hello world message
  li     a7,4                  # a7 <- code of PrintString syscall
  la     a0,hw                 # a0 <- address of hw message
  ecall                        # syscall

# termination
  li     a7,10                 # a7 <- code of Exit syscall
  ecall                        # syscall
