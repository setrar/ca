# 6-os

- Interrupt or Exception:

	- Address of current instruction -> `uepc`
	- LSB of `ustatus` (global interruptable) -> bit 4 of `ustatus`
	- ------------- <- 0
	- Interrupt (1) / Exception (0) -> bit 31$\cdots$0 of `ucause`
	- Interrupt or Exception number -> bits 30...
