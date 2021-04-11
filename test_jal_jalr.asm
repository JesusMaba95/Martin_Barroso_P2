addi t0,zero,4
slli t1,t0,2
auipc s0,0xFC10
addi t0,zero,1
addi t1,zero,2
add  t2,t0,t1
sw t0,(gp)
lw t3,(gp)
bne t1,t2,salto
nop
nop
nop
nop
salto:
	beq zero,t4,salto2
nop
nop
nop
nop
nop
salto2:
	addi t4,t2,3
	addi t5,zero,6
	jal t0,salto3
nop
nop
addi a0,zero,1
nop
nop
salto3:
	jalr a1,t0,8
nop
