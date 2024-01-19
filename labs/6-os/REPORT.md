Study how the exception handler checks if it is an interrupt or an exception and how it branches to the interrupts label in case of an interrupt (more on this part later).


In our simple handler which of these 3 strategies is used for each type of exception?
Do you understand how these 3 cases are implemented in the handler?

The startup code is the piece of code that runs first when we launch the simulation.
Its data and text segments are near the end of the os.s source file.
Study the text segment and try to understand it.


Assemble and simulate.
Is the behavior what you expected?
> yes as we have not implemented yet the code to switch between tasks and taskA runs all the time indefinetly


Assemble and simulate.
Is the behavior what you expected?
> Yes, as the error obtained is:
````
Exception 0 (instruction address misaligned) occurred
Unrecoverable, aborting
````

Reset the simulator ([Run -> Reset]). Set a breakpoint to the faulty jump-and-link instruction you just added.
Simulate; on the breakpoint note the content of sp, pc, the general purpose registers used by the handler, and the ustatus, utvec, uepc, ucause CSRs. Run step-by-step ([Run -> Step]) until we enter the exception handler. Observe the content of the ustatus, utvec, uepc, ucause CSRs. Can you explain their content?
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

Assemble, launch the Timer Tool, connect it to the running program, start the timer, and simulate.
Is the behavior what you expected?
> Yes as the asterisk is being printed every 100ms and also the A's are printed now and then. But not in a predictable way
> *A**A***A**A***A**A***A**A***A**A***A**A***A**A***A**A***A**A**A***A**A***A**A***A***A


Assemble, launch the Timer Tool, connect it to the running program, start the timer, and simulate.
Is the behavior what you expected?
> As the taskB counts longer than taskA, more asterisks are printed in between the B's:
> B*******B********B********B*******B********B*******B*****
>


First list the registers (and other information, if any) that constitute the context of a running task.
> The context will be registers: t0, t1, a0, a7 and pc. I've not included the sp as I don't use the stack in any of the two tasks
> 