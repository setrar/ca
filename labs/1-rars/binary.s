init:
addi t0, zero, 1
shift1: 
slli t1, t0, 1 
i42:
addi t2, zero, 42
mul3:
slli t3, t2, 1
add t2, t2, t3 
s23:
slli t2, t2, 23
t2pt2:
add t2, t2, t2
add t2, t2, t2
add t2, t2, t2
add t2, t2, t2
add t2, t2, t2
add t2, t2, t2
tc:
addi t4, zero,-1
mod128:
addi t3, zero, 1547
andi t4, t3, 0x7f
min:
addi t2, zero, 1
slli t2, t2, 31
m1:
addi t2, t2, -1
rs:
addi t2, zero, 1
slli t2, t2, 31
srli t2, t2, 1
addi t2, zero, 1
slli t2, t2, 31
srai t2, t2, 1
uaddsafe:
add t2, t0, t1
control_add:
bltu t2, t1, ovf_1
bltu t2, t0, ovf_1
addi t3, zero, 0
jal zero, uaddsafe_end
ovf_1: 
addi t3, zero, 1
uaddsafe_end:
# jalr ra, t0, 0
usubsafe:
sub t2, t0, t1
control_sub:
bltu t0, t1, ovf_2
addi t3, zero, 0
jal zero, usubsafe_end
ovf_2:
addi t3, zero, 1
usubsafe_end:
# jalr ra, t0, 0
saddsafe:
add t2, t0, t1
control_add_s:
blt t2, t1, ovf_1_s
blt t2, t0, ovf_1_s
addi t3, zero, 0
jal zero, saddsafe_end
ovf_1_s: 
addi t3, zero, 1
saddsafe_end:
# jalr ra, t0, 0
ssubsafe:
sub t2, t0, t1
control_sub_s:
blt t0, t1, ovf_2_s
addi t3, zero, 0
jal zero, ssubsafe_end
ovf_2_s:
addi t3, zero, 1
ssubsafe_end:
# jalr ra, t0, 0
inv3:
addi t6, zero, 3
addi t5, zero, 1
fmv.s.x ft0, t6
fmv.s.x ft1, t5
fdiv.s ft1, ft1, ft0, rne
finit:
addi t2, zero, 42
addi t3, zero, 1
slli t3, t3, 30
fmv.s.x ft2, t2  
fmv.s.x ft3, t3  
assoc: 
fsub.s ft5, ft3, ft3, rne 
fadd.s ft4, ft2, ft5, rne
assoc2:
fadd.s ft6, ft2, ft3, rne 
fsub.s ft5, ft6, ft3, rne
Nan:
addi t0, zero, 0
fmv.s.x ft0, t0
fdiv.s ft7, ft0, ft0, rne
pinft:
fdiv.s ft8, ft4, ft0, rne
minft:
fsub.s ft10, ft0, ft4, rne
fdiv.s ft9, ft10, ft0, rne

