# data section
.data
kstack:
.space 1024

.text

## example handler function
.global exception_handler
exception_handler:
	csrrw uscratch,sp,zero
	
	sw  t0, 0(sp)
	sw  t1, 4(sp)
    sw  t2, 8(sp)
    sw  t3, 12(sp)
	sw  a0, 16(sp)
	sw  a7, 20(sp)

 	csrrsi a0,ustatus,zero   
    li a7,34               
    ecall
    csrrsi a0,uie,zero      
    li a7,34               
    ecall
    csrrsi a0,utvec,zero    
    li a7,34               
   	ecall
    csrrsi a0,uscratch,zero     
    li a7,34               
    ecall
    csrrsi a0,uepc,zero       
    li a7,34               
    ecall
    csrrsi a0,ucase,zero       
    li a7,34               
    ecall
    	
	lw  t0, 0(sp)
	lw  t1, 4(sp)
    lw  t2, 8(sp)
    lw  t3, 12(sp)
	lw  a0, 16(sp)
	lw  a7, 20(sp)
	
	csrw sp,uscratch 
	
	uret  
