# 6-os

- Interrupt or Exception:

	- Address of current instruction $\implies$ `uepc`
	- LSB of `ustatus` (global interruptable) $\implies$ bit 4 of `ustatus`
	- ------------- <- 0
	- Interrupt (1) / Exception (0) -> bit 31 $\dots$ 0 of `ucause`
	- Interrupt or Exception number -> bits 30 $\dots$ 0 of `ucause`
