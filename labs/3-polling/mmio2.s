.text
.global main

read_func:
    # initialize CPU registers with addresses of transmitter interface registers
    lw    t2,0(a1)                    # t2 <- value of receiver control register
    andi  t2,t2,1                     # mask all bits except LSB
    beq   t2,zero,read_func           # loop if LSB unset (no character from receiver)
    lw    a0,4(a1)  		      # load the value into the a0 register 
    ret
    
write_func:
    # initialize CPU registers with addresses of transmitter interface registers
    lw    t2,0(a2)                    # t2 <- value of transmitter control register
    andi  t2,t2,1                     # mask all bits except LSB
    beq   zero,t2,write_func          # loop if LSB unset (transmitter busy)
    sw    a0, 4(a2)		      # load the value into the a0 register
    ret
   
main: 
    li a1, 0xffff0000                   # a1 <- 0xffff_0000 (address of receiver control register)
    li a2, 0xffff0008                   # a2 <- 0xffff_0008 (address of receiver control register)

main_loop:
    call read_func			# calling the read function
    call write_func			# calling the write function
    li a0, 10				# load the value of new line to the register 
    call write_func			# called again the write function, this time using the value of a new line
    b main_loop 		        # branch to main_loop 

end:                                    # never reached
    li    a7,10
    ecall

    

