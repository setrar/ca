.text
.global main

read_func:
    # initialize CPU registers with addresses of transmitter interface registers
    li    t0,0xffff0000               # t0 <- 0xffff_0000 (address of receiver control register)
    li    t1,0xffff0004               # t1 <- 0xffff_0004 (address of receiver data register)
    lw    t2,0(t0)                    # t2 <- value of receiver control register
    andi  t2,t2,1                     # mask all bits except LSB
    beq   t2,zero,read_func           # loop if LSB unset (no character from receiver)
    lw    a0,0(t1)  
    ret
    
write_func:
    # initialize CPU registers with addresses of transmitter interface registers
    li    t0,0xffff0008               # t0 <- 0xffff_0008 (address of transmitter control register)
    li    t1,0xffff000c               # t1 <- 0xffff_000c (address of transmitter data register)
    lw    t2,0(t0)                    # t2 <- value of transmitter control register
    andi  t2,t2,1                     # mask all bits except LSB
    beq   zero,t2,write_func          # loop if LSB unset (transmitter busy)
    sw    a0, 0(t1)
    ret
   
main: 
    call read_func
    call write_func
    li a0, 10
    call write_func
    b main 


    

