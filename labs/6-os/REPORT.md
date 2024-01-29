### Lab 6: OS - Efrén BOYARIZO GARGALLO

# Report
> For this lab, I've decided to take my implementation from lab 4 instead of the `.io.s` given.
> 
> This means that my implementation differs both in the text printed in the terminal and the behavior of when an overflow or NaN occurs. It will wait for the user to press enter to show the message of overflow or NaN.

> Implementation wise, looking at the given `.io.s` file I found a couple of errors related to detecting overflows in my program. The solution was to compare with the maximum value allowed previously to the multiplication by 10. If its greater then we know an overflow will occur.
>
> Regarding the modifications to implement the timer, no problems were found except for some difficulties in the interrupt routine which due to its nature is both hard to implement with new different instructions and also to debug due to not being able to breakpoint inside of it. The solution I found was to print at every step to detect which instruction was being the problem.

# Questions

#### Q: Study how the exception handler checks if it is an interrupt or an exception and how it branches to the interrupts label in case of an interrupt (more on this part later).


#### Q: In our simple handler which of these 3 strategies is used for each type of exception? Do you understand how these 3 cases are implemented in the handler?

#### Q: The startup code is the piece of code that runs first when we launch the simulation. Its data and text segments are near the end of the os.s source file. Study the text segment and try to understand it.


#### Q: Assemble and simulate. Is the behavior what you expected?
> yes as we have not implemented yet the code to switch between tasks and taskA runs all the time indefinetly


#### Q: Assemble and simulate. Is the behavior what you expected?
> Yes, as the error obtained is:
````
Exception 0 (instruction address misaligned) occurred
Unrecoverable, aborting
````

#### Q: Reset the simulator ([Run -> Reset]). Set a breakpoint to the faulty jump-and-link instruction you just added. Simulate; on the breakpoint note the content of sp, pc, the general purpose registers used by the handler, and the ustatus, utvec, uepc, ucause CSRs. Run step-by-step ([Run -> Step]) until we enter the exception handler. Observe the content of the ustatus, utvec, uepc, ucause CSRs. Can you explain their content?
> Before executing the instruction:
> sp	2	0x7fffeffc
> pc		0x00400148
> ustatus	0	0x00000001
> utvec	5	0x00400000
> uepc	65	0x00000000
> ucause	66	0x00000000
>
> After jumping to the exception handler:
> sp	2	0x7fffeffc
> pc		0x00400000
> ra	1	0x0040014c
> pc		0x00400000
> ustatus	0	0x00000010
> utvec	5	0x00400000
> uepc	65	0x00400122
> ucause	66	0x00000000

#### Q: Assemble, launch the Timer Tool, connect it to the running program, start the timer, and simulate. Is the behavior what you expected?
> Yes as the asterisk is being printed every 100ms and also the A's are printed now and then. But not in a predictable way
> *A**A***A**A***A**A***A**A***A**A***A**A***A**A***A**A***A**A**A***A**A***A**A***A***A


#### Q: Assemble, launch the Timer Tool, connect it to the running program, start the timer, and simulate. Is the behavior what you expected?
> As the taskB counts longer than taskA, more asterisks are printed in between the B's:
> B*******B********B********B*******B********B*******B*****
>


#### Q: First list the registers (and other information, if any) that constitute the context of a running task.
> The context will be registers: t0, t1, a0, a7 and pc. I've not included the sp as I don't use the stack in any of the two tasks
> 