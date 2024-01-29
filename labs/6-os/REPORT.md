### Lab 6: OS - Efrén BOYARIZO GARGALLO

# Report
> To implement the basic function of the OS I've decided to do it the easy way and limit the OS to only have a maximum of two tasks running at the same time. I've also not included the stack pointer in the registers to save as I don't use the stack in any of the two tasks.
>
> To do so, I've reserved some space in the kernel stack to store two copies of the registers t0, t1, a0, a7 and pc (the address of the instruction before the interrupt occurred):
> 1. The slot 1 is to store a copy of the current running task so that it becomes possible to overwrite the current registers with the ones of the next task.
> 2. The slot 2 is to store the registers of the task that will be executed next
> 
> The stack looks like this:
```
                ┌───┬───┬───┬───┬───┬───┬───┬───┐
                │+00│+04│+08│+0c│+10│+14│+18│+1c│
Registers       ├───┴───┴───┴───┼───┴───┴───┴───┘
task      ────► │ t0  t1  a0  a7│ t0  t1  a0  a7
running now     └───┬───────────┴───────┬────────
                  pc│ t0  t1  a0  a7  pc│
                ──▲─┴─────────────────▲─┴────────
                  │                   │
                  │                   │
             [slot 1]             [slot 2]
             Registers            Registers
               task                 next
              running               task
                now
             (copy+pc)
```
> To make it possible to switch between the two tasks, the following steps are required:
> 1. Copy the registers stored by the interruption (plus the register uepc containing the resume address) into the slot 1
> 2. Copy the contents of the registers of slot 2 into the ones that will be restored at the end of the interrupt (plus restore the value of uepc)
> 3. Copy the slot 1 into slot 2 so that the task will be executed in the next interrupt
>

> The last step to make it work is to initialize the slot 2 with the registers of the taskB (if taskA is the first one to run). To do it, I've copied the address the label taskB into the place in the stack that hold the PC in slot 2, so that it starts executing taskB after the first interrupt.

# Questions

#### Q: In our simple handler which of these 3 strategies is used for each type of exception?
> If the exception type is a breakpoint or some syscall then it will skip the instruction and continue executing.
> Else it will end the execution of the program and print out the error

#### Q: (os_1.s) Assemble and simulate. Is the behavior what you expected?
> Yes as we have not implemented yet the code to switch between tasks and taskA runs all the time indefinitely


#### Q: (Modify the code of taskA.s to cause an instruction address misaligned exception) Assemble and simulate. Is the behavior what you expected?
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
>
> As explained in the lab 5, they will contain the values to determine what caused the interruption, the type of exception and the value of the PC before it happened.

#### Q: (os_2.s with taskA) Assemble, launch the Timer Tool, connect it to the running program, start the timer, and simulate. Is the behavior what you expected?
> Yes as the asterisk is being printed every 100ms and also the A's are printed now and then. But not in a predictable way because the timer is interrupting its execution:
````
*A**A***A**A***A**A***A**A***A**A***A**A***A**A***A**A***A**A**A***A**A***A**A***A***A
````


#### Q: (os_2.s with taskB) Assemble, launch the Timer Tool, connect it to the running program, start the timer, and simulate. Is the behavior what you expected?
> As the taskB counts longer than taskA, more asterisks are printed in between the B's:
````
B*******B********B********B*******B********B*******B*****
````


#### Q: First list the registers (and other information, if any) that constitute the context of a running task.
> The context will be registers: t0, t1, a0, a7 and pc. I've not included the sp as I don't use the stack in any of the two tasks
> 