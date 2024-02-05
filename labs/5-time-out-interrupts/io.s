# data section
.data

# messages
enter_int_message:
.asciz "\nPlease enter an unsigned integer followed by newline (0 to quit) "
not_a_digit_message:
.asciz "\nThe character you entered is not a digit!\n"
overflow_message:
.asciz "\nThe integer you entered is too large to fit on 32 bits!\n"
print_int_message:
.asciz "\nYou entered integer "
print_at:
.asciz " at "
print_milliseconds:
.asciz " milliseconds."
bye_message:
.asciz "\nBye!"
timeout_message:
.asciz "\nTimeout error!"

# symbols
.eqv MAX   429496729  # max value prior multiplication by 10
.eqv KCTRL 0xffff0000 # address of keyboard control register
.eqv KDATA 0xffff0004 # address of keyboard data register
.eqv DCTRL 0xffff0008 # address of display control register
.eqv DDATA 0xffff000c # address of display data register
.eqv OVERR 2          # error code for overflow
.eqv NDERR 1          # error code for not-a-digit
.eqv NOERR 0          # error code for no error
.eqv TMOERR 4         # error code for timeout
.eqv TIME 5000        # set the value of the timer up to 5000ms

# time-out flag
.global time_out
time_out:
.word 0

# code section
.text


# set_timer function 
set_timer:
    addi  sp,sp,-16
    sw    ra,0(sp)
		li   t0,0xffff0018
		lw   t0,(t0)
		add  t1,t0,a0
		li   t2,0xffff0020
		sw   t1,(t2)
		csrrsi zero,uie,16
		lw   ra,0(sp)
    addi sp,sp,16
    ret
	
# read character, return read character in a0
getc:
    addi  sp,sp,-32          # allocate stack frame
    sw    ra,0(sp)           # save ra
    li    a0,TIME            # store the value 5000 ms into the register
    call  set_timer          # call the function 
    la    t0,time_out   		 # Load the address of the time_out flag
    sw    zero,0(t0)				 # reset the timeout flag
    li    t0,KCTRL           # t0 <- address of keyboard control register
    li    t1,KDATA           # t1 <- address of keyboard data register
getc_wait:
	  la    t2,time_out        # load the timeout flag value
    lw    t3,0(t2)			     # load the content in the address t2 into t3 
    bnez  t3,time_out_error  # branch to time_out error if the content of t3 is not equal to 0
    li    a1,NOERR           # load the no error code 
    lw    t2,0(t0)           # t2 <- value of keyboard control register
    andi  t2,t2,1            # mask all bits except LSB
    beq   t2,zero,getc_wait  # loop if LSB unset (no character from keyboard)
    lw    a0,0(t1)           # store received character in a0
    lw    ra,0(sp)           # restore ra
    addi  sp,sp,32           # deallocate stack frame, restore stack pointer
    ret                      # return

# print character in a0
putc:
    addi  sp,sp,-32          # allocate stack frame
    sw    ra,0(sp)           # save ra
    sw    a0,4(sp)
    li    a0,TIME            # store the value 5000 ms into the register
    call  set_timer          # call the function 
    lw    a0,4(sp)           # load word 
    la    t0,time_out   		 # Load the address of the time_out flag
    sw    zero,(t0)
    li    t0,DCTRL           # t0 <- address of display control register
    li    t1,DDATA           # t1 <- address of display data register
putc_wait:
	  la    t2,time_out        # load the timeout flag value
    lw    t3,0(t2)			 # load the content in the address t2 into t3 
    bnez  t3,time_out_error   # branch to time_out error if the content of t3 is not equal to 0
    li    a1, NOERR           # load the no error code 
    lw    t2,0(t0)           # t2 <- value of display control register
    andi  t2,t2,1            # mask all bits except LSB
    beq   zero,t2,putc_wait  # loop if LSB unset (display busy)
    sw    a0,0(t1)           # send character
    lw    ra,0(sp)           # restore ra
    addi  sp,sp,32           # deallocate stack frame, restore stack pointer
    ret                      # return

# use only a one time_out_error function for both getc and putc
time_out_error:
    li    a1,TMOERR          # load the error value 
    lw    ra,0(sp)
    addi  sp,sp,32
    ret

# print NUL-terminated string stored in memory at address in a0
print_string:
    addi  sp,sp,-32          # allocate stack frame
    sw    ra,0(sp)           # save ra
    sw    s0,4(sp)           # save s0
    mv    s0,a0              # s0 <- a0
    li    a1,NOERR           # no error 
print_string_loop:
    lbu   a0,0(s0)           # a0 <- next character
    beq   a0,zero,print_string_end  # if NUL character goto print_string_end
    call  putc               # send character to display
    bnez  a1,print_string_end # got ot end if I obtain an error
    addi  s0,s0,1            # s0 <- s0+1 (next character)
    b     print_string_loop  # goto print_string_loop
print_string_end:
    lw    ra,0(sp)           # restore ra
    lw    s0,4(sp)           # restore s0
    addi  sp,sp,32           # deallocate stack frame, restore stack pointer
    ret                      # return

# convert character to integer
d2i:
    addi  sp,sp,-32      # allocate stack frame
    sw    ra,0(sp)       # save ra
    li    a1,NDERR       # a1 <- not-a-digit error code
    li    t0,'9'         # t0 <- ASCII code of character '9'
    blt   t0,a0,d2i_end  # if t0 < a0 goto d2i_end
    li    t0,'0'         # t0 <- ASCII code of character '0'
    blt   a0,t0,d2i_end  # if a0 < t0 goto d2i_end
    sub   a0,a0,t0       # convert to integer
    li    a1,NOERR       # a1 <- no error code
d2i_end:
    lw    ra,0(sp)       # restore ra
    addi  sp,sp,32       # deallocate stack frame, restore stack pointer
    ret                  # return

# read integer, return read integer in a0
# return error code in a1:
# - OVERR if overflow
# - NDERR if user entered not-a-digit character
# - NOERR if no error
geti:
    addi  sp,sp,-32         # allocate stack frame
    sw    ra,0(sp)          # save ra
    sw    s0,4(sp)          # save s0
    sw    s1,8(sp)          # save s1
    li    s0,0              # s0 <- 0
    li    s1,10             # s1 <- 10
    li    a1,0              # load immediate value 0 to the register a1
geti_loop:
    call  getc              # get character
    bnez  a1,geti_end			  # branch to end if the value in a1 is not equal to 0
    beq   a0,s1,geti_ok     # if character is newline goto geti_ok
    call  d2i               # convert character to integer
    bne   a1,zero,geti_end  # if error goto geti_end
    li    a1,OVERR          # a1 <- overflow error code
    li    t0,MAX            # t0 <- MAX
    bltu  t0,s0,geti_end    # if t0 < s0 goto geti_end (overflow)
    mul   t0,s0,s1          # t0 <- s0 * 10
    add   s0,t0,a0          # s0 <- t0 + a0
    bltu  s0,t0,geti_end    # if s0 < t0 goto geti_end (overflow)
    b     geti_loop         # loop
geti_ok:
    mv    a0,s0             # a0 <- s0 (entered integer)
    li    a1,NOERR          # a1 <- no error code
geti_end:
    lw    ra,0(sp)          # restore ra
    lw    s0,4(sp)          # restore s0
    lw    s1,8(sp)          # restore s1
    addi  sp,sp,32          # deallocate stack frame, restore stack pointer
    ret                     # return
    
# print integer in a0
puti:
    addi  sp,sp,-32         # allocate stack frame
    sw    ra,0(sp)          # save ra
    sw    s0,4(sp)          # save s0
    li    t0,10             # t0 <- 10
    li    a1,0							# a1 <- 0
    rem   s0,a0,t0          # s0 <- a0 % 10
    div   a0,a0,t0          # a0 <- a0 / 10
    beq   a0,zero,puti_done # if a0 == 0 goto puti_done
    call  puti              # recurse
puti_done:
    addi  a0,s0,'0'         # a0 <- s0 + '0' (ASCII code of digit to print)
    call  putc              # print digit
    lw    ra,0(sp)          # restore ra
    lw    s0,4(sp)          # restore s0
    addi  sp,sp,32          # deallocate stack frame, restore stack pointer
    ret                     # return

# main function, read an integer, print it, goto end if it is 0, else continue
.global main
main:
#loading the exception handler 
		la     t0,exception_handler  # load the exception handler 
		csrrw  zero,utvec,t0         # load the base address of the exception handler 
		csrrsi zero,ustatus,1				 # enbling the interrupts
		
		li     a0,TIME 							 # load value 5000\
		call 	 set_timer             # call the set_timer function 

    la    a0,enter_int_message   # print message
    call  print_string
    call  geti                   # read integer
    andi  t0,a1,NDERR            # test error code
    bne   t0,zero,main_nad
    andi  t0,a1,OVERR            # test error code
    bne   t0,zero,main_ovf
    li    t1,TMOERR							 # load timeout error 
    beq   a1,t1,timeout_end      
    mv    s0,a0                  # copy read integer in s0
    la    a0,print_int_message   # print message
    call  print_string
    mv    a0,s0                  # copy read integer in a0
    call  puti                   # print read integer
    la    a0,print_at 					 # call the second print string function
    call  print_string
  	lw    a0,0xffff0018
  	csrrw t1,uscratch,a0
  	call  puti
  	la    a0,print_milliseconds
  	call  print_string
    li    a0,'\n'                # a0 <- newline
    call  putc
    li    t0,TMOERR
    beq   a1,t0,timeout_end
    mv    a0,s0
    call  puti
    li    t0,TMOERR
    beq   a1,t0,timeout_end
    li    a0,'\n'
    call  putc
    li    t0,TMOERR
    beq   a1,t0,timeout_end
    bne   s0,zero,main           # loop if read integer is not 0
main_end:
    la    a0,bye_message         # print message
    call  print_string
    li    t0,TMOERR
    beq   a1,t0,timeout_end
    li    a7,10                  # syscall code for Exit
    ecall
main_nad:
    la    a0,not_a_digit_message
    call  print_string
    b     main
main_ovf:
    la    a0,overflow_message
    call  print_string
    b     main
timeout_end:
    la    a0,timeout_message
    call  print_string
    li    a7,10                  # syscall code for Exit
    ecall
