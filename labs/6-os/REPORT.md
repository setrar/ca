# 6-os

Started but unfinished :x:

Note: 
- SW interrupts (uip)
- Relax constraints (only answer questions no code needed)
- Reports + Source Code du on 6/2 at 23:59


## User tasks

- [x] Task A
- [x] Task B

| task context | from | to |
|--------------|------|----|
| 1) general purp reg. | | |
| 2) Stack | | | 
| 3) PC | | |

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
	

- Generate a timer (SW Interrupts) 

```
csr uip
```
