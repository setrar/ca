# data section
.data
kstack:
.space 1024

.text
## example handler function
.global exception_handler
exception_handler:
	csrrw t0,uscratch,sp     
	la  sp,kstack							
	addi sp,sp,-24
	sw  t0, 0(sp)
	sw  t1, 4(sp)
  sw  t2, 8(sp)
	sw  t3, 12(sp)
	sw  a0, 16(sp)
	sw  a7, 20(sp)
	
	li  t0,0x80000004      # check if both the interrupt enable and the timer interrupt are activated 
	csrrs t1,ucause,zero
	bne  t0,t1,finish
	
	la t1,time_out
	addi t2,zero,1
	sw t2,0(t1)
  csrrsi zero,uie,0     # disable the time interrupts
 	
  li a7,34               
  #ecall
  csrrsi a0,uie,0                    
  #ecall
  csrrsi a0,utvec,0              
  #ecall
  csrrsi a0,uscratch,0               
  #ecall
  csrrsi a0,uepc,0            
  #ecall
  csrrsi a0,ucause,0                     
  #ecall

finish: 
	lw  t0, 0(sp)
	lw  t1, 4(sp)
  lw  t2, 8(sp)
  lw  t3, 12(sp)
	lw  a0, 16(sp)
	lw  a7, 20(sp)
	csrrw sp,uscratch,zero 
	uret  
