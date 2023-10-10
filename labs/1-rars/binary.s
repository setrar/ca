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