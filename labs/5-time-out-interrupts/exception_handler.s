# data section
.data
kstack:
.space 1024


.text
.global exception_handler
exception_handler:
	csrrw zero, uscratch, sp
	la sp, kstack
	addi  sp,sp,-4
    	sw    t0,0(sp)
    	addi  sp,sp,-4
    	sw    t1,0(sp)
    	addi  sp,sp,-4
    	sw    t2,0(sp)
    	addi  sp,sp,-4
    	sw    t3,0(sp)
    	addi  sp,sp,-4
    	sw    a0,0(sp)
    	addi  sp,sp,-4
    	sw    a7,0(sp)
    	
    	# Check if is interrupt of timer
    	li t0, 0x80000004
    	csrrsi  t1,ucause,0
    	bne t0, t1, exception_handler_exit
    	
    	# If timeout then set flag to 1
    	la t2, time_out
    	addi t3, zero, 1
    	sw t3,(t2)
    	# Disable interrupts
    	csrrsi  zero,ustatus,0
    	
    	#li   a7, 34       # system call to print via terminal
    	#csrrsi  a0,ustatus,0
	#ecall           
    	#csrrsi  a0,uie,0
	#ecall           
    	#csrrsi  a0,utvec,0
	#ecall           
    	#csrrsi  a0,uscratch,0
	#ecall           
    	#csrrsi  a0,uepc,0
	#ecall           
    	#csrrsi  a0,ucause,0 
	#ecall  
	#addi a0, sp, 0 
	#ecall           

exception_handler_exit:  	
    	lw    a7,0(sp)
    	addi  sp,sp,4
    	lw    a0,0(sp)
    	addi  sp,sp,4
    	lw    t3,0(sp)
    	addi  sp,sp,4
    	lw    t2,0(sp)
    	addi  sp,sp,4
    	lw    t1,0(sp)
    	addi  sp,sp,4
    	lw    t0,0(sp)
    	addi  sp,sp,4
    	csrrw sp, uscratch, zero
    	uret
    	