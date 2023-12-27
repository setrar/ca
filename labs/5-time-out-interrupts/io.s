# data section
.data

# text messages
enter_number_message:
.asciz "\nPlease enter a number (0 to quit): "
print_error_nad:
.asciz "\nThe number you entered is not a digit! Try with only numbers"
print_error_overflow:
.asciz "\nThe number you entered is too long to process! Try with something smaller"
print_error_timeout:
.asciz "\nTimeout! Program will exit now"
print_number_message:
.asciz "\nYou entered integer "
print_number_message2:
.asciz " at "
print_number_message3:
.asciz " milliseconds."
bye_message:
.asciz "\nBye!"

.eqv MAX_MULT_10 429496729 # max value prior multiplication by 10

# time-out flag
.global time_out
time_out:
.word 0

# code section
.text

# function: set_timer
# description: sets up the timer interrupt with the value given
# parameters: time in milliseconds in a0
# return: none
set_timer:
    addi  sp,sp,-4          # allocate stack frame (1 register to save = 1*4 = 4 bytes)
    sw    ra,0(sp)          # save ra on stack
    
    li t0, 0xffff0018         # Get the current timestamp on when the number was inputed
    lw t0, (t0)               # Save the time in t0
    add a0, a0, t0          # Add timeout to current time
    li t0, 0xffff0020       # Store the new timeout timestamp into timecmp
    sw a0, (t0)
    csrrsi  zero,uie,16      # Enable timer interrupts
    
    lw    ra,0(sp)          # restore ra from stack
    addi  sp,sp,4           # deallocate stack frame, restore stack pointer
    ret                     # return to caller

# function: getc
# description: read character from keyboard
# parameters: none
# return: ASCII code of read character in a0, timeout error in a1 (=4)
getc:
    addi  sp,sp,-4          # allocate stack frame (1 register to save = 1*4 = 4 bytes)
    sw    ra,0(sp)          # save ra on stack
    li a0, 5000             # Load 5000ms into a0
    call set_timer          # Call set timer and set the timeout flag to 0
    la t6, time_out
    sw zero, (t6)
    li t0, 0xffff0000       # Load MMIO base address
loop_getc: 
    lw t1, (t6)             # If we timeout jump to set flag equal to 4
    bnez t1, timeout_getc
    lw t1,0(t0)             # t2 <- value of receiver control register
    andi  t1,t1,1           # mask all bits except LSB
    beq   t1,zero,loop_getc # loop if LSB unset (no character from receiver)
    lw    a0,4(t0)          # Read word 
    addi a1, zero, 0        # Set error flag to 0
    j exit_getc
timeout_getc:
    addi a1, zero, 4        # Set error flag to 4
exit_getc:
    lw    ra,0(sp)          # restore ra from stack
    addi  sp,sp,4           # deallocate stack frame, restore stack pointer
    ret                     # return to caller

# function: putc
# description: print character to console
# parameters: ASCII code of character to print in a0
# return: timeout error in a1 (=4)
putc:
    addi  sp,sp,-4          # allocate stack frame (1 register to save = 1*4 = 4 bytes)
    sw    ra,0(sp)          # save ra on stack
    addi a1, a0, 0	    
    li a0, 5000             # Load 5000ms into a0
    call set_timer          # Call set timer and set the timeout flag to 0
    la t6, time_out
    sw zero, (t6)
    addi a0, a1, 0          # Move back the original value of a0
    li t0, 0xffff0000       # Load MMIO base address
loop_putc: 
    lw t1, (t6)             # If we timeout jump to set flag equal to 4
    bnez t1, timeout_getc
    lw    t1,8(t0)          # t2 <- value of transmitter control register
    andi  t1,t1,1           # mask all bits except LSB
    beq   zero,t1,loop_putc # loop if LSB unset (transmitter busy)
    sw    a0,12(t0)         # send character received from receiver to transmitter
    addi a1, zero, 0        # Set error flag to 0
    j exit_putc
timeout_putc:
    addi a1, zero, 4        # Set error flag to 4
exit_putc:    
    lw    ra,0(sp)          # restore ra from stack
    addi  sp,sp,4           # deallocate stack frame, restore stack pointer
    ret                     # return to caller

# function: print_string
# description: print a string to console
# parameters: address of string stored in a0 (must be NULL terminated)
# return: error flag in a1
print_string:
    addi  sp,sp,-4          # allocate stack frame (1 register to save = 1*4 = 4 bytes)
    sw    ra,0(sp)          # save ra on stack
    addi a2, a0, 0          # Save the address parameter into a2
    lb a0,(a2)              # Load byte from the address
    beq a0,zero,string_end  # Check if the byte is not the null terminator
string_loop: 
    call putc               # Print the character!
    bnez a1, string_end     # Exit the loop if we could not print the character!
    addi a2,a2,1            # Move onto the next character
    lb a0,(a2)              # Load byte from the address
    bne a0,zero,string_loop # If byte is not null terminator, loop again to print next character
string_end: 
    lw    ra,0(sp)          # restore ra from stack
    addi  sp,sp,4           # deallocate stack frame, restore stack pointer
    ret                     # return to caller

# function: d2i
# description: convert ASCII code for numbers into decimal values (for character from '0' to '9'). If conversion is not possible return 1 in a1
# parameters: ASCII character stored in a0
# return: decimal character stored in a0, error flag stored in a1
d2i:
    addi  sp,sp,-4        # allocate stack frame (1 register to save = 1*4 = 4 bytes)
    sw    ra,0(sp)        # save ra on stack
    addi t0,zero,'0'    # store limits of the conversion
    addi t1,zero,'9'          
    bgt a0,t1,d2i_error # if value is not between '0' and '9' set flag to 1
    blt a0,t0,d2i_error       
    addi a0,a0,-48      # convert to base 10 (substract 48 which is the value of 0)
    j d2i_no_error        # jump directly to no_error to prevent the flag from being set
d2i_error: 
    addi a1,zero,1      # set flag to 1 to indicate error in conversion
    addi a0,zero,0      # set character to 0 (we don't really care about the value as flag=1)
    j d2i_exit            # exit function with flag=1
d2i_no_error:
    addi a1,zero,0      # set flag to 0 as conversion was succesful
d2i_exit: 
    lw    ra,0(sp)        # restore ra from stack
    addi  sp,sp,4         # deallocate stack frame, restore stack pointer
    ret                   # return to caller        


# function: geti
# description: read an unsinged integer from the terminal
# parameters: none
# return: number in a0, error flag in a1
geti:
    addi  sp,sp,-4      # allocate stack frame (1 register to save = 1*4 = 4 bytes)
    sw    ra,0(sp)      # save ra on 
    addi t2,zero,'\n'   # store new line character in a2 (to know when to stop)
    addi t3,zero,10     # store 10 (to multiply each value)
    addi s1,zero,0      # initialize register
    addi a1,zero,0      # set error to 0
geti_loop:
    call getc                  # get character
    bnez a1, geti_exit         # Exit the loop if we could not get the character!
    beq a0,t2,geti_exit        # if character is new line, exit loop
    call d2i                   # convert character to base 10
    bnez a1,geti_nad           # if error, then wait for new line but with not a digit error
    li t4,MAX_MULT_10          # t4 <- MAX_MULT_10
    bltu t4,s1,geti_overflow   # if current number exceeds the max number we can multiply by 10 then we know it overflowed
    mul s1, s1, t3             # multiply previous number by 10
    add t4, s1, a0             # add the new digit and store it in a temporary register to detect overflow
    bltu t4,s1, geti_overflow  # if after adding the new digit we get a lower number than before we know it overflowed
    addi s1, t4, 0             # save new number
    j geti_loop
geti_nad:                      # not a digit error: set flag to 1
    call getc                  # get character
    bne a0,t2,geti_nad         # if character is new line, exit loop
    addi a1, zero, 1
    j geti_exit
geti_overflow:                 # overflow error: set flag to 2
    call getc                  # get character
    bne a0,t2,geti_overflow    # if character is new line, exit loop
    addi a1, zero, 2
    j geti_exit
geti_exit: 
    addi a0, s1, 0
    lw    ra,0(sp)             # restore ra from stack
    addi  sp,sp,4              # deallocate stack frame, restore stack pointer
    ret                        # return to caller

# function: puti
# description: print number into the terminal
# parameters: number to print in a0
# return: none
# notes: uses a3 as a parameter to call itself (recursion). This parameter is set by default to a0/10
# notes: register a2 is set to 10 (to divide by 10), error flag in a1
puti:
    addi  a3,zero, 0      # set register a3 to 0
    addi  a2,zero,10      # set a2 to 10 (for base10 division)
puti_recursion:
    addi  sp,sp,-12       # allocate stack frame (3 register to save = 3*4 = 12 bytes)
    sw    ra,0(sp)        # save ra 
    divu a3, a0, a2       # divide number by 10
    sw    a0,4(sp)        # save a0 for future use
    sw    a3,8(sp)        # save a3 for future use
    beqz a3, puti_print   # check if we can start printing characters, if so skip calling this function again
    addi a0, a3, 0        # if we have not yet reached the most significant character, call again this function but with a0=a0/10
    call puti_recursion                           
puti_print:               # if we reach this point, we can start to print the next characters
    bnez a1, puti_end     # Exit the loop if we could not print the previous character!
    lw a0,4(sp)           # recover original values for a0 and a3 from the stack
    lw a3,8(sp)
    mul a3, a3, a2        # get least significant digit -> a0 - a3*10
    sub  a0, a0, a3
    addi a0, a0, 48       # convert to ASCII
    call putc		  # print character
puti_end:
    lw    ra,0(sp)        # restore ra from stack
    addi  sp,sp,12        # deallocate stack frame, restore stack pointer
    ret                   # return to caller


# function: main
# description: read number from keyboard, print it to console, goto end if number is 0, else restart from beginning
# parameters: none
# return: none
.global main
main:
    la t0, exception_handler  # Copy interrupt handler address into utvec
    csrrw zero, utvec, t0
    csrrsi  zero,ustatus,1  # Enable global interrupts

    la    a0,enter_number_message # store address of message in a0
    call print_string             # print enter a number message
    call  geti                    # call geti function to read integer
    # check for errors in geti and print messages accordingly
    addi t1, zero, 1
    addi t2, zero, 2
    addi t3, zero, 4
    beq a1, t1, main_error_nad
    beq a1, t2, main_error_overflow
    beq a1, t3, main_error_timeout
    beq a1, zero, main_puti
main_error_nad:   
    la    a0,print_error_nad      # store address of message in a0
    call print_string	          # print error message
    j main                        # loop again!
main_error_overflow:
    la    a0,print_error_overflow # store address of message in a0
    call print_string             # print error message
    j main                        # loop again!
main_error_timeout:
    la    a0,print_error_timeout # store address of message in a0
    call print_string             # print error message
    j main_exit                        # loop again!
main_puti:
    mv    s0,a0                   # copy read integer in s0
    li a0, 0xffff0018         # Get the current timestamp on when the number was inputed
    lw s1, (a0)               # Save the time in s1	
    csrw s1, uscratch
    la    a0,print_number_message # store address of message in a0
    call print_string
    mv    a0,s0                   # copy read integer into a0
    call  puti                    # call puti function to print integer
    la    a0,print_number_message2 # store address of message in a0
    call print_string
    mv    a0,s1                   # copy time integer into a0
    call  puti                    # call puti function to print integer
    la    a0,print_number_message3 # store address of message in a0
    call print_string
    bne   s0,zero,main            # loop if read integer is not 0
    la    a0,bye_message          # store address of message in a0
    call print_string             # print bye message
main_exit:
    li    a7,10                   # store code of Exit syscall in a7
    ecall                         # call syscall
