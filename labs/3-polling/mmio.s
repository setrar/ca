# Polling-based IO (simple) example

.text
.global main
main:


init_rcv:
	# initialize CPU registers with addresses of receiver interface registers
    li    t0,0xffff0000               # t0 <- 0xffff_0000 (address of receiver control register)
    li    t1,0xffff0004               # t1 <- 0xffff_0004 (address of receiver data register)
wait_for_rcv:
    lw    t2,0(t0)                    # t2 <- value of receiver control register
    andi  t2,t2,1                     # mask all bits except LSB
    beq   t2,zero,wait_for_rcv        # loop if LSB unset (no character from receiver)
    addi  a1, zero, 1
    lw    a0,0(t1)                    # store received character in a0

init_trans:
    # initialize CPU registers with addresses of transmitter interface registers
    li    t0,0xffff0008               # t0 <- 0xffff_0008 (address of transmitter control register)
    li    t1,0xffff000c               # t1 <- 0xffff_000c (address of transmitter data register)
wait_for_trans:
    lw    t2,0(t0)                    # t2 <- value of transmitter control register
    andi  t2,t2,1                     # mask all bits except LSB
    beq   zero,t2,wait_for_trans      # loop if LSB unset (transmitter busy)
    beqz  a1, transmited
not_transmited:
    sw    a0,0(t1)                    # send character received from receiver to transmitter
    addi  a1, zero, 0
    b     wait_for_trans
transmited:
    li    t3,10                       # ASCII code of newline
    sw    t3,0(t1)                    # send newline character to transmitter

end_loop:
    b     init_rcv                # go to wait_for_rcv (infinite loop)

end:                                  # never reached
    li    a7,10
    ecall
