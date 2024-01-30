## Luca NEPOTE

## lab 6

# User tasks
Following the instructions given in the assignment, we wrote the "taskA.s" program, and verified that it worked correctly.

We also built the "taskB.s" one, according to the specifications given. Also in this case the correct behavior of the program has been verified.

# Understanding the starting point of the mini-OS
Considering the first instruction of the exception handler, the `uscratch` is the CSR from which the actual value is read and to which the new value will be written. With the instruction "csrrw  zero,uscratch,sp" we are reading the current value from `uscratch`, writing this the new value of the stack pointer and storing the old value of `uscratch` into register `zero`. In this way we'll be able to restore the content of the stack pointer when we finish the execution of the exception handler. After that we load the address of the kernel stack pointer into `sp`. We can use this to save more registers adding offset to `sp`. At the end, in the "ret" function, we restored the registers in the opposite way.

The instruction for checking if we are dealing with 'n' interrupt or an exception is "csrrsi t0,ucause,0", with which we read the current value from `ucause`, perform a bitwise OR operation with `0` in order to check the first bit (and the corresponding interrupt/exception), we set that bits in `ucause` and store the old value of that into `t0`. Using the syscall is then possible to print the error message corresponding to the different exceptions. 
Moreover we use `uepc` and `uret` respectively to store and to return to the address of the operation that has been interrupted by the exception handler.

8) We check for the exception code in order to recognize the different types of exception. We saved the exception code in `t0`, and check with '3', corresponding to the breakpoint. If it is, we branch to skip, when we return back to the main program but we skip the instruction in order to avoid infinite loop. The same holds for the case of an environmental code exception. If instead, we are not dealing with these two types of exceptions, the program is restored from where it has been interrupted. (check with Vlad)!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

9) When the event is an interrupt, in order to choose the correct interrupt service routine, the program stores in `t1` the correct offset of the interrupt code, then it loads into `a0` the base address of the ISR and add the correct offset. We load the address and jump to the correct interrupt service routine.

10) Considering the startup code, we initially load the address of the exception handler, then initialize the `utvec` CSR with its address. We the globally enable the interrupts by setting a '1' in the LSB of the `ustatus` CSR. At the end, a text message is printed and it exits.

# Change the RARS settings
Simulating the behavior of the program "os.s" we obtained what we expected, with the program printing the string "Hello, world!" and exiting. 

# Call a user task, test an exception

After following the procedure in the assignment, the system is working as expected, printing at first the sentence "Hello world!" and then printing the character `A` in loop.

According to the instructions, we modified the code in the "taskA.s" in order to cause an exception: we stored the value of the taskA address, add a displacement of '2' and then try to jump at the general purpose register. Doing this the program causes an exception: at first it prints "Hello world!", and `A` and then it stops. The behavior is the one that we expected, with the program stopping because of the type of exception.

starting point

sp: 0x7fffeffc

pc: 0x00400154

ustatus:0x00000001 (the processor is in user mode)

utvec:0x00400000

uepc:0x00000000

ucause:0x00000000


step1

sp: 0x7fffeffc

pc: 0x00400122 (changed)

ustatus:0x00000001

utvec:0x00400000 (base address of the exception)

uepc:0x00000000

ucause:0x00000000 (no exception or interrupt has occurred yet)
 

step2

sp: 0x7fffeffc

pc: 0x00400000 (changed)

ustatus:0x00000010 (changed) (change in the processor status)

utvec:0x00400000

uepc:0x0040122 (changed) (the value represents the memory address where the `pc` was at time of exception. 

ucause:0x00000000


step3(uscratch changed, saving the content of sp)

sp: 0x7fffeffc

pc: 0x00400004 (changed)

ustatus:0x00000010 

utvec:0x00400000

uepc:0x0040122 

ucause:0x00000000


The content of the `ustatus`, `utvec`,`uepc` and `ucause` CSR does not changed till the exception is reached.

At the end, we commented the lines of code involving the exception.
