# Assignments

## The time-out flag

${\color{Blue} A_n}$

1. Edit the `io.s` source file. In the data section add a declaration for a 32-bits word that we will use for the time-out flag, with a global label for easy reference:

```asm
# time-out flag
.global time_out
time_out:
.word 0
```

2. Add a `set_timer` function that takes a delay in milliseconds in register a0 but does nothing and returns.
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

3. At the beginning of `getc` and `putc` functions call `set_timer` with parameter 5000 (5 seconds) and reset the time-out flag.

```asm
    li a0, 5000              # Call set_timer with parameter 5000 (5 seconds)
    call set_timer
    la t0, time_out
    sw zero, 0(t0)           # Reset the time-out flag to 0
```

4. Modify the polling loops of `getc` and `putc` such that they watch the time-out flag and return error code 4 in `a1` if the value of the time-out flag is not 0.

5. Adapt the code of the `print_string`, `geti` and `puti` functions such that they handle this new error code and return it to their own caller functions, still in `a1`.
For all functions check that they return value 0 in `a1` if there is no error.

6. Adapt the code of the `main` function such that it prints a dedicated error message and exits if there is a time-out error.
Of course, do not check for another time-out error while printing the dedicated error message.
Do you understand why we use values 1, 2 and 4 for the error codes, and not 1, 2 and 3?


7. Assemble with RARS, launch the `Keyboard and Display MMIO simulator` tool, connect it to the program, simulate, debug if needed and verify that it behaves as expected.
As we have no way yet to set the time-out flag during the simulation we are not be able to really test the time-out feature; the new version shall behave as the original one.

## The timer tool

&#x1F5E3; Answers:

1. Launch the Timer Tool, connect it to the running program, start the timer, wait a few seconds and pause it.

<img src=images/LAB5_TimerTool.png width='30%' height='30%' > </img>


2. In the Data Segment sub-window of RARS select the 0xffff0000 (MMIO) memory region and look at the current value of time.

<img src=images/LAB5_TimerTool-reading.png width='' height='' > </img>


3. Does it correspond to the current time of the Timer Tool window?

Yes, `5761 ms` seems to match the `00:05.61` value 

4. Modify the io.s code

```asm
# TBD
```

5. Assemble with RARS,

```asm
# TBD
```


# References

```asm
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
