# Assignments

## The time-out flag


1. Edit the io.s source file. In the data section add a declaration for a 32-bits word that we will use for the time-out flag, with a global label for easy reference:

```asm
# time-out flag
.global time_out
time_out:
.word 0
```

2. Add a set_timer function that takes a delay in milliseconds in register a0 but does nothing and returns.
Later we will modify it to initialize a timer.

```asm
# code section
.text

# function: set_timer
# description: sets the timers initial values
# parameters: none
# return: nothing for now
# notes: ret is a pseudo-instruction
set_timer:
    addi  sp,sp,-32          # allocate stack frame
    sw    ra,0(sp)           # save ra

    la t0, time_out
    sw zero, 0(t0)           

    lw    ra,0(sp)           # restore ra
    addi  sp,sp,32           # deallocate stack frame, restore stack pointer    
    ret                      # Return
```

3. At the beginning of getc and putc functions call set_timer with parameter 5000 (5 seconds) and reset the time-out flag.

```asm
    li a0, 5000              # Call set_timer with parameter 5000 (5 seconds)
    call set_timer
    la t0, time_out
    sw zero, 0(t0)           # Reset the time-out flag to 0
```

## The timer tool

&#x1F5E3; Note:

<img src=images/LAB5_TimerTool.png width='30%' height='30%' > </img>

<img src=images/LAB5_TimerTool-reading.png width='' height='' > </img>

# References

```assembly
csrrw t0, csr, t1    # does:    to <- csr || csr <- t1
csrrc t0, csr, t1    # does:    to <- csr || csr <- (not t1) and csr
csrrs t0, csr, t1    # does:    to <- csr || csr <- t1 or csr

# All have immediate 
csrrwi t0, csr, 0x10
csrrci t0, csr, 0x11
csrrsi t0, csr, 0x01

```

```assembly
uip # u Interrup Pending registers
```
