auipc s0,0xFC10
addi t0,zero,4
addi t1,zero,3
add  t2,t0,t1
sub  s0,t2,t0
mul  a0,t2,t1
sw t0,0(gp)
lw a1,0(gp)