# data section
.data

# text messages
enter_integer_message:
.asciz "\nPlease enter a integer number (0 to quit): "
print_integer_message:
.asciz "\nThe number you entered is: "
bye_message:
.asciz "\nBye!"
print_ascii_message:
.asciz "\nThe ASCII code of the character you entered is:"
not_a_digit_message:
.asciz "\nPlease insert an integer digit!\n"
overflow_message:
.asciz "\nOverflow error! The number inserted can't be represented in 32 bits!\n"

# code section
.text

# function: getc
# description: read character from keyboard
# parameters: none
# return: ASCII code of read character in a0
# notes: ret is a pseudo-instruction
getc:
    lw    t2,0(a5)                    # t2 <- value of receiver control register
    andi  t2,t2,1                     # mask all bits except LSB
    beq   t2,zero,getc                # loop if LSB unset (no character from receiver)
    lw    a0,4(a5)  		      # load the value into the a0 register 
    li    a1,0			      # set the value of a1 to 0 (NOT SURE, BECAUSE WE WOULD HAVE TO CHECK FOR THE CHARACTER!!)
    ret                               # return to caller

# function: putc
# description: print character to console
# parameters: ASCII code of character to print in a0
# return: none
# notes: ret is a pseudo-instruction
putc:
    lw    t2,0(a6)                    # t2 <- value of transmitter control register
    andi  t2,t2,1                     # mask all bits except LSB
    beq   zero,t2,putc                # loop if LSB unset (transmitter busy)
    sw    a0, 4(a6)		      # load the value into the a0 register
    ret				      # return to caller
    
# function: puti
# description: print integer in register a0
# parameters: ASCII code of character to print in a0
# return: none
# notes: ret is a pseudo-instruction
# modified version of puti function 
puti:
    addi  sp,sp,-4    		# allocate stack frame 
    sw    ra,0(sp)    		# save ra on stack
    sw    s0,4(sp)           	# save s0
    li    t0,10                 # load the value 10
    rem   s0,a0,t0              # reminder 
    div   a0,a0,t0              # performs the division between a0 and t0
    bnez  a0,puti		# branch to puti if a0 is not equal to zero 
    addi  a0,s0,'0'             # ascii code 
    call  putc			# in order to print the digit 
    bnez  a1,puti_close         # branch to puti_close 
       
    
puti_close:
    lw ra,0(sp)  		# restore ra
    lw s0,4(sp)  		# restore s0
    addi sp,sp,32 		# deallocate stack frame, restore stack pointer
    ret
   
# print_string function  
print_string:
    addi  sp,sp,-32          	# allocate stack frame
    sw    ra,0(sp)           	# save ra
    sw    s0,4(sp)           	# save s0
    mv    s0,a0              	# s0 <- a0
    
print_string_loop:   
    lbu   a0,0(s0)           	# a0 <- next character
    beqz  a0,print_string_close # go to end if the character is queal to zero
    call  putc	             	# call the function to print the character
    addi  s0, s0, 1          	# take the next character
    b     print_string_loop 	# if a0 not equal to zero, branch to print_string_loop to take the new character

print_string_close:
    lw    ra,0(sp)  		# restore ra
    lw    s0,4(sp)  		# restore s0
    addi  sp,sp,32 		# deallocate stack frame, restore stack pointer
    ret
    
# d2i function 
d2i:
    addi  sp,sp,-32          	# allocate stack frame
    sw    ra,0(sp)           	# save ra
    li    a1,1 			# not a digit error 
    li    t3,'0'		# load the character 0
    blt   a0,t3,d2i_close	# branch to end if the value is not a number between 0 and 9
    li    t4,'9'		# load the character 9
    blt   t4,a0,d2i_close	# branch to end if the value is not a number between 0 and 9
    li    a1,0                  # if it is an integer, load 0 value 
    sub   a0,a0,t3              # conversion to a decimal number 
 	
d2i_close:  
    lw s0,4(sp)  		# restore s0
    addi sp,sp,32 		# deallocate stack frame, restore stack pointer
    ret

# geti function 
geti:
    addi  sp,sp,-32         # allocate stack frame
    sw    ra,0(sp)          # save ra
    sw    s0,4(sp)          # save s0
    sw    s1,8(sp)          # save s1
    li    s0,0              # load character '0'
    li    s1,10             # load character "new line"
    
geti_loop:
    call  getc 		    # call the getc function to get the character
    li    t0,1              # load value 1 to check if the character is an integer
    li    t1,2              # load value 1 to check if the integer is in overflow or not 
    beq   a1,t0,geti_close  # end function if the value in a0 is not an integer
    beq   a1,t1,geti_close  # end function if the value in a0 is in overflow 
    beq   s1,a0,new_line    # if there is a new line, go to end 	
    call  d2i               # call the d2i function
    beq   a1,t0,geti_close  # end function if the value in a0 is not an integer
    beq   a1,t1,geti_close  # end function if the value in a0 is in overflow 
    li    a1,2              # overflow error 
    li    t2,429496729      # load the max acceptable value 
    bgtu  s0,t2,geti_close  # go to end with overflow error 
    li    t3,10             # load the value 10 in t3
    mul   t4,s0,t3          # updating of the value (multiplication operation)
    add   s0,t4,a0          # updating of the value in s0
    bgtu  s0,t2,geti_close  # checking again the overflow error 
     
new_line:
    mv a0,s0                # copy the value into register a0
    li a1,0                 # no error  
    
geti_close:  
    lw ra,0(sp)  	    # restore ra
    lw s0,4(sp)  	    # restore s0
    lw s1,8(sp)  	    # restore s1
    addi sp,sp,32 	    # deallocate stack frame, restore stack pointer
    ret
    

# function: main
# description: read character from keyboard, print it to console, goto end if
#              character is 'Q', else restart from beginning
# parameters: none
# return: none
# notes: la, li, call, mv are pseudo-instructions
.global main
main:
    la    a0,enter_integer_message 	# store address of message in a0
    li    a5, 0xffff0000                # a1 <- 0xffff_0000 (address of receiver control register)
    li    a6, 0xffff0008                # a2 <- 0xffff_0008 (address of receiver control register)
    call  print_string           	# call print_string function 
    call  geti                  	# call getc function to read character
    andi  t1,a1,1                       # check not a digit error 
    beqz  t1,not_a_digit                # branch to not_a_digit if the value in a1 is 1
    andi  t1,a1,2                       # check overflow error 
    beqz  t1,overflow                   # branch to noverflow if the value in a1 is 2
    mv    s0,a0       			# copy read character in s0
    la    a0,print_integer_message 	# store address of message in a0
    li    a7,4        			# store code of PrintString syscall in a7
    call  print_string           	# call print_string function 
    mv    a0,s0       			# copy read character in a0
    call  puti        			# call putc function to print character
    li    t0,'0'      			# store 'Q' ASCII code in t0
    bne   a0,t0,main  			# loop if read character is not '0'
    la    a0,bye_message 		# store address of message in a0
    li    a7,4        			# store code of PrintString syscall in a7
    call  print_string           	# call print_string function 
    li    a7,10      			# store code of Exit syscall in a7
    call  print_string           	# call print_string function 
    
not_a_digit:
    la    a0,not_a_digit_message        # not a digit message 
    call  print_string                  # go to print string
    b     main                          # branch to main 
    
overflow:
    la    a0,overflow_message           # overflow 
    call  print_string                  # go to print_string
    b     main                          # branch to main 
