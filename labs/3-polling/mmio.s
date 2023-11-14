# Polling-based IO (simple) example

.text
.global main
# function: read
# description: reads character from terminal
# parameters: address of pheripherals in a2
# return: character stored in a0
read:
    # initialize CPU registers with addresses of receiver interface registers
    lw    t2,0(a2)                    # t2 <- value of receiver control register
    andi  t2,t2,1                     # mask all bits except LSB
    beq   t2,zero,read                # loop if LSB unset (no character from receiver)
    lw    a0,4(a2)                    # store received character in a0
    ret
   
# function: write
# description: reads character f
# parameters: character to print in a0, address of pheripherals in a2
# return: none
write:
    # initialize CPU registers with addresses of transmitter interface registers
    lw    t2,8(a2)                    # t2 <- value of transmitter control register
    andi  t2,t2,1                     # mask all bits except LSB
    beq   zero,t2,write               # loop if LSB unset (transmitter busy)
    sw    a0,12(a2)                    # send character received from receiver to transmitter
    ret


main:
    li a2,0xffff0000  # Load address of peripherals into function argument a2
    call read    # Read byte from terminal and store it in a0
    call write   # Print read byte (currently in a0)
    li    a0,10  # Store ASCII code of newline in a0
    call write   # Print new line (currently in a0)
    b     main   # Infinite loop
