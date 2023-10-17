bar:
  slli a2, a2, 2 # a2 = i * 4
  add a0, a0, a2 # a0 = T + i * 4
lw t0, 0(a0)