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

# symbols
.eqv MAX   429496729  # max value prior multiplication by 10
.eqv KCTRL 0xffff0000 # address of keyboard control register
.eqv KDATA 0xffff0004 # address of keyboard data register
.eqv DCTRL 0xffff0008 # address of display control register
.eqv DDATA 0xffff000c # address of display data register
.eqv TDATA 0xffff0018 # address of timer data register
.eqv OVERR 2          # error code for overflow
.eqv NDERR 1          # error code for not-a-digit
.eqv NOERR 0          # error code for no error
.eqv TIME  5000       # TODO add comment
.eqv COMP  0xffff0020 # TODO add comment

# time-out flag
.global time_out
time_out:
.word 0

# code section
.text

# function: set_timer
# description: sets the timers initial values
# parameters: none
# return: nothing for now
# notes: ret is a pseudo-instruction
set_timer:
    addi  sp,sp,-32           # allocate stack frame
    sw    ra,0(sp)           # save ra
   
    # Load memory address 0xffff0018 into t0 and read its value
    li t0, TDATA
    lw t0, (t0)

    # Calculate the new timer value by adding a0 to the loaded value from 0xffff0018
    add t1, t0, a0

    # Store the new timer value into memory address 0xffff0020
    li t2, 0xffff0020
    sw t1, (t2)

    # Enable user-level interrupts by setting bit 16 in uie CSR
    csrrsi zero, uie, 16
    
#    la t0, time_out          # la expects a label
#    sw zero, 0(t0)           
#    li t0, 5000              # li (load immediate) expects a value
#    lw t0, 0(t0)
#    add a0, t0, a0
#    li t0, COMP
#    sw a0,0(t0)

    lw    ra,0(sp)           # restore ra
    addi  sp,sp,32           # deallocate stack frame, restore stack pointer    
    ret                      # Return
    
    

# function: timeout_error
# description: sets the register a1 to 4
# parameters: none
# return: nothing for now
# notes: ret is a pseudo-instruction
timeout_error:
  # Set error code to 4 in a1
  li a1, 4
  # Return with error code
  ret

# read character, return read character in a0
getc:
    addi  sp,sp,-32          # allocate stack frame
    sw    ra,0(sp)           # save ra
        
    li    a0, TIME           # Call set_timer with parameter 5000 (5 seconds)
    call  set_timer
    la    t0, time_out
    sw    zero, 0(t0)        # Reset the time-out flag to 0
        
    li    t0,KCTRL           # t0 <- address of keyboard control register
    li    t1,KDATA           # t1 <- address of keyboard data register
      
getc_wait:
    lw    t2,0(t0)           # t2 <- value of keyboard control register
    andi  t2,t2,1            # mask all bits except LSB
      
    lw a2, time_out          # Load timeout flag
    bnez a2, timeout_error  # Check the timeout flag
    
    beq   t2,zero,getc_wait  # loop if LSB unset (no character from keyboard)
    lw    a0,0(t1)           # store received character in a0
    lw    ra,0(sp)           # restore ra
    addi  sp,sp,32           # deallocate stack frame, restore stack pointer
    ret                      # return

# print character in a0
putc:
    addi  sp,sp,-32          # allocate stack frame
    sw    ra,0(sp)           # save ra
    sw    s0,4(sp)           # store to saved register s0 to preserve a0 used by putc
    mv    s0,a0              # Store s0 <- a0

    #############
    # sw    a0,4(sp)
    # li    a0, 5000              # Call set_timer with parameter 5000 (5 seconds)
    # call  set_timer
    # lw    a0,4(sp)
    #############

    li    a0, TIME           # Call set_timer with parameter 5000 (5 seconds)
    call  set_timer
    la    t0, time_out
    sw    zero, 0(t0)        # Reset the time-out flag to 0

    mv    a0, s0             # move a0 <- s0  to restore the saved a0 registry used by putc


    li    t0,DCTRL           # t0 <- address of display control register
    li    t1,DDATA           # t1 <- address of display data register
putc_wait:
    lw    t2,0(t0)           # t2 <- value of display control register
    andi  t2,t2,1            # mask all bits except LSB

    lw    a2, time_out          # Load timeout flag
    bnez  a2, timeout_error  # Check the timeout flag

    beq   zero,t2,putc_wait  # loop if LSB unset (display busy)
    sw    a0,0(t1)           # send character
    lw    s0,4(sp)
    lw    ra,0(sp)           # restore ra
    addi  sp,sp,32           # deallocate stack frame, restore stack pointer
    ret                      # return

# print NUL-terminated string stored in memory at address in a0
print_string:
    addi  sp,sp,-32          # allocate stack frame
    sw    ra,0(sp)           # save ra
    sw    s0,4(sp)           # save s0
    mv    s0,a0              # s0 <- a0
print_string_loop:
    lbu   a0,0(s0)           # a0 <- next character
    beq   a0,zero,print_string_end  # if NUL character goto print_string_end
    call  putc               # send character to display
    addi  s0,s0,1            # s0 <- s0+1 (next character)
    b     print_string_loop  # goto print_string_loop
print_string_end:
    lw    ra,0(sp)           # restore ra
    lw    s0,4(sp)           # restore s0 used to save a0
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
geti_loop:
    call  getc              # get character
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
    rem   s0,a0,t0          # s0 <- a0 % 10
    div   a0,a0,t0          # a0 <- a0 / 10
    beq   a0,zero,puti_done # if a0 == 0 goto puti_done
    call  puti              # recurse
puti_done:
    addi  a0,s0,'0'         # a0 <- s0 + '0' (ASCII code of digit to print)
    call  putc              # print digit
puti_end:
    lw    ra,0(sp)          # restore ra
    lw    s0,4(sp)          # restore s0
    addi  sp,sp,32          # deallocate stack frame, restore stack pointer
    ret                     # return

# main function, read an integer, print it, goto end if it is 0, else continue
.global main
main:
    
    la     t0, exception_handler # Load the address of the exception_handler    
    csrrw  zero, utvec, t0       # Set the User Trap Vector (utvec) CSR with the base address of the exception handler
    csrrsi zero, ustatus, 0x01   # Enable Supervisor User Interrupts (SUIE) by setting the ustatus CSR's "UIE" bit (bit 1) to 1
    
    # csrrsi zero, uie, 0x10       # enabling timer interrupt by setting the uie bit
     
    la    a0,enter_int_message   # print message
    call  print_string
    call  geti                   # read integer
    andi  t0,a1,NDERR            # test error code
    bne   t0,zero,main_nad
    andi  t0,a1,OVERR            # test error code
    bne   t0,zero,main_ovf
    mv    s0,a0                  # copy read integer in s0
    la    a0,print_int_message   # print message
    call  print_string
    mv    a0,s0                  # copy read integer in a0
    call  puti                   # print integer
    la    a0,print_at 		
    call  print_string           # print at
    lw    a0, TDATA              # Load a value from TIME memory address into register a0
    csrrw t1, uscratch, a0       # Store the value from a0 into the uscratch CSR and save the previous value in t1
    call  puti                   # print integer
    la    a0, print_milliseconds # Load the address of the "print_milliseconds" string into a0
    call  print_string           # Call the print_string function to print the string
    li    a0,'\n'                # a0 <- newline
    call  putc
    bne   s0,zero,main           # loop if read integer is not 0
main_end:
    la    a0,bye_message         # print message
    call  print_string
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
