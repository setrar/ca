

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

<img src=images/LAB5_TimerTool.png width='30%' height='30%' > </img>

<img src=images/LAB5_TimerTool-reading.png width='' height='' > </img>
