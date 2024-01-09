# data section
.data
.global time_out
time_out:
.word 0

# messages
enter_int_message:
.asciz "\nPlease enter an unsigned integer followed by newline (0 to quit) "
not_a_digit_message:
.asciz "\nThe character you entered is not a digit!\n"
overflow_message:
.asciz "\nThe integer you entered is too large to fit on 32 bits!\n"
print_int_message:
.asciz "\nYou entered integer "
print_int_time_message:
.asciz " at "
print_time_message:
.asciz " milliseconds."
bye_message:
.asciz "\nBye!"
time_out_error_message:
.asciz "\nThere was a timeout!"

# symbols
.eqv MAX   429496729  # max value prior multiplication by 10
.eqv KCTRL 0xffff0000 # address of keyboard control register
.eqv KDATA 0xffff0004 # address of keyboard data register
.eqv DCTRL 0xffff0008 # address of display control register
.eqv DDATA 0xffff000c # address of display data register
.eqv TIMERESG 0xffff0018 # address of time register
.eqv TIMECMPRESG 0xffff0020 # address of timecmp register
.eqv OVERR 2          # error code for overflow
.eqv NDERR 1          # error code for not-a-digit
.eqv NOERR 0          # error code for no error
.eqv TIMEERROR 4      # error code for timeout

# code section
.text

# Timer function
set_timer:
    addi   sp, sp, -4
    sw     ra, 0(sp)

    li     t0, TIMERESG
    add    t0, t0, a0
    li     t1, TIMECMPRESG
    sw     t0, 0(t1)
    csrrsi zero, uie, 16     # enable timer interrupts

    lw     ra, 0(sp)
    addi   sp, sp, 4
    ret

# read character, return read character in a0
getc:
    addi  sp,sp,-32          # allocate stack frame
    sw    ra,0(sp)           # save ra
    sw    s0, 4(sp)
    sw    s1, 8(sp)
    sw    s2, 12(sp)

    li    s0,KCTRL           # t0 <- address of keyboard control register
    li    s1,KDATA           # t1 <- address of keyboard data register
    mv    s2, a0
    li    a0, 5000
    call  set_timer
    la	  t3, time_out
    sw    zero, 0(t3)
    mv    a0, s2
getc_wait:
    lw    t2,0(s0)           # t2 <- value of keyboard control register
    lw	  t3, time_out
    bnez  t3, time_out_error
    andi  t2,t2,1            # mask all bits except LSB
    beq   t2,zero,getc_wait  # loop if LSB unset (no character from keyboard)
    lw    a0,0(s1)           # store received character in a0
    mv    a1, zero

    lw    ra,0(sp)           # restore ra
    lw    s0, 4(sp)
    lw    s1, 8(sp)
    lw    s2, 12(sp)
    addi  sp,sp,32           # deallocate stack frame, restore stack pointer
    ret                      # return

# print character in a0
putc:
    addi  sp,sp,-32          # allocate stack frame
    sw    ra,0(sp)           # save ra
    sw    s0, 4(sp)
    sw    s1, 8(sp)
    sw    s2, 12(sp)

    li    s0,DCTRL           # t0 <- address of display control register
    li    s1,DDATA           # t1 <- address of display data register
    mv    s2, a0
    li    a0, 5000
    call  set_timer
    la	  t3, time_out
    sw    zero, 0(t3)
    mv    a0, s2
putc_wait:
    lw    t2,0(s0)           # t2 <- value of display control register
    lw	  t3, time_out
    bnez  t3, time_out_error
    andi  t2,t2,1            # mask all bits except LSB
    beq   zero,t2,putc_wait  # loop if LSB unset (display busy)
    sw    a0,0(s1)           # send character

    lw    ra,0(sp)           # restore ra
    mv    a1, zero
    lw    s0, 4(sp)
    lw    s1, 8(sp)
    lw    s2, 12(sp)
    addi  sp,sp,32           # deallocate stack frame, restore stack pointer
    ret                      # return

time_out_error:
    li    a1, TIMEERROR
    lw    ra, 0(sp)
    lw    s0, 4(sp)
    lw    s1, 8(sp)
    lw    s2, 12(sp)
    addi  sp, sp, 32
    ret

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
    bnez  a1, print_string_end
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
geti_loop:
    call  getc              # get character
    bnez  a1, geti_end
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
    addi   s1, zero, TIMEERROR
    la     t0, exception_handler  # store address of exception handler
    csrrw  zero, utvec, t0
    csrrsi zero, ustatus, 1       # enable all interrupts
    li     a0, 5000
    call   set_timer
    la     a0,enter_int_message   # print message
    call   print_string
    call   geti                   # read integer

    andi   t0,a1,NDERR            # test error code
    bne    t0,zero,main_nad
    andi   t0,a1,OVERR            # test error code
    bne    t0,zero,main_ovf
    beq    a1, s1, main_error_timeout
    mv     s0,a0                  # copy read integer in s0
    la     a0,print_int_message   # print message
    call   print_string
    beq    a1, s1, main_error_timeout
    mv     a0,s0                  # copy read integer in a0
    call   puti                   # print read integer
    beq    a1, s1, main_error_timeout
    la     a0,print_int_time_message
    call   print_string
    beq    a1, s1, main_error_timeout
    lw     a0, TIMERESG
    csrrw  zero, uscratch, a0
    call   puti
    la     a0,print_time_message
    call   print_string
    li     a0,'\n'                # a0 <- newline
    call   putc
    bne    s0,zero,main           # loop if read integer is not 0
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
main_error_timeout:
    la    a0, time_out_error_message
    li    a7, 4
    ecall
    b     main_end
