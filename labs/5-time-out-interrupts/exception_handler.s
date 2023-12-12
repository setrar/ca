.data
kstack:
.space 1024

.text
.global exception_handler
exception_handler:
	csrrw zero, uscratch, sp
	lw    sp, kstack
	sw    t0, 0(sp)
	sw    t1, 4(sp)
	sw    t2, 8(sp)
	sw    t3, 12(sp)
	sw    a0, 16(sp)
	sw    a7, 20(sp)
	
	addi  a7, zero, 34
	csrrs a0, ustatus, zero
	ecall
	csrrs a0, uie, zero
	ecall
	csrrs a0, utvec, zero
	ecall
	csrrs a0, uscratch, zero
	ecall
	csrrs a0, uepc, zero
	ecall
	csrrs a0, ucause, zero
	ecall

	lw    t0, 0(sp)
	lw    t1, 4(sp)
	lw    t2, 8(sp)
	lw    t3, 12(sp)
	lw    a0, 16(sp)
	lw    a7, 20(sp)
	csrrw sp, uscratch, zero
	uret
