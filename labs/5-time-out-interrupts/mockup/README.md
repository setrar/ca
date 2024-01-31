# Mockup

This mockup test was provided by RARS when pressing `F1` Help and [RISCV -> Exceptions]

```assembly
.text
main:
 	la t0,handler
 	csrrw zero, 5, t0 # set utvec (5) to the handlers address
 	csrrsi zero, 0, 1 # set interrupt enable bit in ustatus (0)
 	lw zero, 0        # trigger trap for Load access fault
 	j main


handler: # Just ignore it by moving epc (65) to the next instruction
	csrrw t0, 65, zero
	addi t0, t0, 4
	csrrw zero, 65, t0
	uret
```

#### In order to have a working exception handler, the program must:
- Set utvec to the address of the handler code (the lowest two bits are special)
- Set the bits corresponding to the handled interrupts in uie
- Set the interrupt enable (lowest) bit in ustatus to enable the handler

And inside the handler, :

- The exception handler can return control to the program using the uret instruction. This will place the uepc CSR value into the Program Counter, so be sure to increment it by 4 before returning if you want to skip over the instruction that caused the exception. It also resets some other state to before the exception, so jumping to the value in uepc instead is not recommended
- ucause contains the reason that the exception handler was called.
- Exception types declared in rars.SimulatorException, but not necessarily implemented, are INSTRUCTION_ADDR_MISALIGNED (0), INSTRUCTION_ACCESS_FAULT (1), ILLEGAL_INSTRUCTION(2), LOAD_ADDRESS_MISALIGNED(4), LOAD_ACCESS_FAULT(5), STORE_ADDRESS_MISALIGNED(6), STORE_ACCESS_FAULT(7), and ENVIRONMENT_CALL(8)
- When writing a non-trivial exception handler, your handler must first save general purpose register contents, then restore them before returning.

* Other comments retrieved from chatGPT

In RISC-V architecture, the `usstatus`, `ucause`, and `uepc` registers are used to handle exceptions and interrupts. The values you provided represent the state of these registers during an exception or interrupt. Let's break down what each of these registers means in this context:

1. `usstatus` (User Status Register):
   - `usstatus = 0x00000001` means that the `usstatus` register contains the value `0x00000001`, which corresponds to a user-level privilege mode. In RISC-V, user mode is the least privileged mode, typically used for regular application code.
   
2. `ucause` (User Cause Register):
   - `ucause = 0x00000005` means that the `ucause` register contains the value `0x00000005`. This value represents an exception or interrupt cause. In this case, `0x00000005` might indicate a specific type of exception, but the exact meaning depends on the RISC-V architecture and the specific configuration of the system.

3. `uepc` (User Exception Program Counter):
   - `uepc = 0x00400018` means that the `uepc` register contains the value `0x00400018`. This value represents the program counter (PC) at the time of the exception or interrupt. It indicates the address of the instruction that was being executed when the exception occurred. In this case, the PC was `0x00400018`.

To determine the specific meaning of the `ucause` value `0x00000005` and the context in which this exception occurred, you would need to refer to the RISC-V architecture documentation and the specific hardware or simulator configuration. Different exceptions or interrupts are assigned unique cause values, and their meanings can vary depending on the system's design and configuration. The `uepc` value `0x00400018` tells you where the exception occurred in memory, but you would need to examine the code at that address to understand the nature of the exception or interrupt.

In RISC-V, the `utvec` (User Trap-Vector Base-Address Register) and `uepc` (User Exception Program Counter) registers are related to handling traps and exceptions.

The `utvec` register specifies the base address of the trap vector table, where the processor looks up the address of the trap handler code when a trap or exception occurs. It holds the address of the first instruction of the trap handler. 

The `uepc` register holds the program counter (PC) value at the time an exception occurred, i.e., the address of the instruction that caused the exception.

In your description:

- `utvec = 0x00400018` means that the base address of the trap vector table is `0x00400018`.
- `uepc = utvec = 0x00400014` means that the `uepc` register also holds the value `0x00400014`.

Typically, when an exception occurs, the processor saves the address of the instruction that caused the exception into `uepc` and then looks up the address of the trap handler in the trap vector table specified by `utvec`. 

If both `utvec` and `uepc` hold the value `0x00400014`, it suggests that the trap handler code is located at `0x00400014`, and that address is also stored in `uepc` because that's where the exception occurred. This configuration is possible, but the actual behavior depends on the specific design of the processor and the trap handling mechanism in use.
