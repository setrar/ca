# data section
.data
kstack:
.space 1024

.text
.global exception_handler
exception_handler:
        csrrw zero, uscratch, sp # Save the current user-level stack pointer (sp) in uscratch
        la sp, kstack # Switch to the kernel-level stack (kstack)
        addi sp, sp, -24 # Allocate space for local variables on the stack
        # Save registers t0, t1, t2, t3, a0, and a7 onto the stack
        sw t0, 0(sp)
        sw t1, 0(sp)
        sw t2, 0(sp)
        sw t3, 0(sp)
        sw a0, 0(sp)
        sw a7, 0(sp)
        
        li t0, 0x80000004     # Check if the exception cause is external interrupt
        csrrsi t1, ucause, 0
        bne t0, t1, exception_handler_end
        
        la t2, time_out  # If it's an external interrupt, set the time_out flag to 1
        addi t3, zero, 1
        sw t3, (t2)
        csrrsi zero, uie, 0 # Enable user-level interrupts by clearing the uie bit

exception_handler_end: 
        # Restore registers from the stack
        lw a7, 0(sp)
        lw a0, 0(sp)
        lw t3, 0(sp)
        lw t2, 0(sp)
        lw t1, 0(sp)
        lw t0, 0(sp)
        addi sp, sp, 24 # Deallocate local variable space on the stack
        csrrw sp, uscratch, zero # Restore the user-level stack pointer from uscratch
        uret # Return from the exception handling routine
