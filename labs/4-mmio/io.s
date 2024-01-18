# data section
.data

# text messages
enter_int_message:
.asciz "\nPlease enter a integer (0 or nothing to quit): "
print_char_message:
.asciz "\nThe character you entered is: "
print_number_message:
.asciz "\nThe number you entered is: "
bye_message:
.asciz "\nBye!"
notanumber_message:
.asciz "\nThis is not a number!"
overflow_message:
.asciz "\nOpps, this number does not fit on 32 bits."

# code section
.text

# function: getc
# description: read character from keyboard
# parameters: none
# return: ASCII code of read character in a0
# notes: ret is a pseudo-instruction
getc:
    addi  sp, sp, -4    # allocate stack frame (1 register to save = 1*4 = 4 bytes)
    sw    ra, 0(sp)     # save ra on stack
    li    t0, 0xffff0000           # t0 <- 0xffff_0000 (address of receiver control register)
    li    t1, 0xffff0004           # t1 <- 0xffff_0004 (address of receiver data register)
wait_for_rcv:
    lw    t2, 0(t0)                # t2 <- value of receiver control register
    andi  t2, t2, 1                # mask all bits except LSB
    beq   t2, zero, wait_for_rcv   # loop if LSB unset (no character from receiver)
    lw    a0, 0(t1)                # store received character in a0

    lw    ra, 0(sp)     # restore ra from stack
    addi  sp, sp, 4     # deallocate stack frame, restore stack pointer
    ret                 # return to caller

# function: putc
# description: print character to console
# parameters: ASCII code of character to print in a0
# return: none
# notes: ret is a pseudo-instruction
putc:
    addi  sp, sp, -4    # allocate stack frame (1 register to save = 1*4 = 4 bytes)
    sw    ra, 0(sp)     # save ra on stack
    li    t0, 0xffff0008              # t0 <- 0xffff_0008 (address of transmitter control register)
    li    t1, 0xffff000c              # t1 <- 0xffff_000c (address of transmitter data register)
wait_for_trans:
    lw    t2, 0(t0)                   # t2 <- value of transmitter control register
    andi  t2, t2, 1                   # mask all bits except LSB
    beq   zero, t2, wait_for_trans    # loop if LSB unset (transmitter busy)
    sw    a0, 0(t1)                   # send character received from receiver to transmitter

    lw    ra, 0(sp)     # restore ra from stack
    addi  sp, sp, 4     # deallocate stack frame, restore stack pointer
    ret                 # return to caller

puti:
	addi sp, sp, -8
	sw	 ra, 0(sp)
	sw	 s0, 4(sp)
	li   t0, 10
	rem  s0, a0, t0     # get a0 % 10
	div  a0, a0, t0     # divide the input by 10
	beqz a0, puti_print # if a0 = 0, then we need to go out of the loop
	call puti
puti_print:
	addi a0, s0, '0'
	call putc
	lw 	 ra, 0(sp)
	lw 	 s0, 4(sp)
	addi sp, sp, 8
	ret

print_string:
	addi sp, sp, -12
	sw   ra, 0(sp)     # Store the registers we will use
	sw   s0, 4(sp)
	sw   s1, 8(sp)
	add  s0, a0, zero
loop_print:
	lb   a0, 0(s0)
	addi s0, s0, 1
	call putc
	bnez a0, loop_print

	lw   ra, 0(sp)
	lw   s0, 4(sp)     # Put the register back in place
	lw   s1, 8(sp)
	addi sp, sp, 12
	ret

d2i:
	addi sp, sp, -4
	sw   ra, 0(sp)
	li   t0, '0'     # takes ascii code for '0'
	li   t1, '9'     # takes ascii code for '9'
	blt  a0, t0, error_d2i
	bgt  a0, t1, error_d2i
	sub  a0, a0, t0
	add  a1, zero, zero    # set error code to 0
	b end_d2i
error_d2i:
	addi a1, zero, 1       # set error code to 1
end_d2i:
	lw   ra, 0(sp)
	addi sp, sp, 4
	ret

geti:
	addi sp, sp, -12
	sw   ra, 0(sp)
	sw   s0, 4(sp)
	sw   s1, 8(sp)

	add  s0, zero, zero
	li   s1, '\n'
geti_startloop:
	call getc
	beq  a0, s1, geti_endstring
	call d2i
	bnez a1, geti_notanumber
	add  t0, zero, s0   # copy old value
	addi t1, zero, 10
	mul  t0, t0, t1     # multiply old value by 10
	add  t0, t0, a0     # add entered number to the value
	blt  t0, s0, geti_overflow  # detect overflow
	add  s0, t0, zero   # copy new value in saved register
	b    geti_startloop
geti_endstring:
	la   a0, print_number_message
	call print_string
	add  a0, s0, zero
	call puti
	add  a1, zero, zero    # set error code to 0
	b    geti_endloop
geti_overflow:
	la   a0, overflow_message
	call print_string
	addi a1, zero, 2       # set error code to 2
	b    geti_endloop
geti_notanumber:
	la   a0, notanumber_message
	call print_string
	addi a1, zero, 1       # set error code to 1
	b    geti_endloop
geti_endloop:
	lw   ra, 0(sp)
	lw   s0, 4(sp)
	lw   s1, 8(sp)
	addi sp, sp, 12
	ret

# function: main
# description: read character from keyboard, print it to console, goto end if
#              character is 'Q', else restart from beginning
# parameters: none
# return: none
# notes: la, li, call, mv are pseudo-instructions
.global main
main:
    la    a0, enter_int_message # store address of message in a0
    call print_string

    call  geti          # call getc function to read character

    li    t0, '0'       # store 'Q' ASCII code in t0
    bne   a0, t0, main  # loop if read character is not '0'

    la    a0, bye_message # store address of message in a0
    call print_string
    li    a7, 10        # store code of Exit syscall in a7
    ecall               # call syscall
