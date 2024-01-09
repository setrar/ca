### Lab 5: Time-out interrupts - Efrén BOYARIZO GARGALLO

# Report
> For this lab, I've decided to take my implementation from lab 4 instead of the `.io.s` given.
> 
> This means that my implementation differs both in the text printed in the terminal and the behavior of when an overflow or NaN occurs. It will wait for the user to press enter to show the message of overflow or NaN.

> Implementation wise, looking at the given `.io.s` file I found a couple of errors related to detecting overflows in my program. The solution was to compare with the maximum value allowed previously to the multiplication by 10. If its greater then we know an overflow will occur.
>
> Regarding the modifications to implement the timer, no problems were found except for some difficulties in the interrupt routine which due to its nature is both hard to implement with new different instructions and also to debug due to not being able to breakpoint inside of it. The solution I found was to print at every step to detect which instruction was being the problem.

# Questions

#### Q: Do you understand why we use values 1, 2 and 4 for the error codes, and not 1, 2 and 3?
> Because timeout error is of different kind to NaD or overflow, and we want to make a distinction

#### Q: Does it correspond to the current time of the Timer Tool window?
> Yes it corresponds to the current number of seconds multiplied by 1000 (for minutes we have to multiply by 60000)

#### Q: Try to explain these values:
> `ustatus` = 0x00000010, corresponds to 0b10000, bit 0 has been copied to bit 4 and cleared to prevent interrupts inside the interrupt handler
>
> `uie` = 0x00000010, bit 4 is enabled, which corresponds to the timer interrupt
> 
> `utvec` = 0x00400000, address of where the interrupt handler is located in memory
> 
> `uscratch` = 0x7fffeff4, the value of the SP, it has been copied to uscratch at the beginning of the exception handler
> 
> `uepc` = 0x00400114, corresponds to the currently executing instruction address as it is the PC for exceptions
> 
> `ucause` = 0x80000004, bit 31 is 1 indicating is an interrupt and the rest of the bits represent the interrupt code for timer

#### Q: What instruction was currently executing when the timer interrupt occurred?
> The instruction located at the current value of `PC=uscratch=0x7fffeff4` which corresponds to the instruction that loads the value of the control register for checking if a new character is waiting to be read from MMIO:
```
lw t1,0(t0)    # t2 <- value of receiver control register
```

#### Q: What is the timer interrupt code?
> The numeric code for timer interrupts can be found in the bits 30 to 0 in ucause. At the time of the exception, its value is 0x4.

#### Q: How do you know this was an interrupt and not an exception with the same code?
> Bit 31 in ucause indicated weather is an interrupt or an exception (1 for interrupts and 0 for exceptions) we can check it within our code to determine the type.
