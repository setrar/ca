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




