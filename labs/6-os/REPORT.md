# 6-os


## User tasks

- [x] Task A
- [x] Task B

# References

- Interrupt or Exception:

	- Address of current instruction $\implies$ `uepc`
	- LSB of `ustatus` (global interruptable) $\implies$ bit 4 of `ustatus`
	- ------------- <- 0
	- Interrupt `(1)` / Exception `(0)` $\implies$ bit 31 $\dots$ 0 of `ucause`
	- Interrupt or Exception number -> bits 30 $\dots$ 0 of `ucause`
	- Jump at `utvec`

- `uret` (Interrupt / Exception return):

	- bit 4 of `ustatus` $\implies$ bit 0 of `ustatus`
    - ------------- <- 0
	- Jump at `uepc`
	
