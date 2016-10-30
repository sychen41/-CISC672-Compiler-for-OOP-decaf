	# standard Decaf preamble 
	.data
TRUE:
	.asciiz "true"
FALSE:
	.asciiz "false"
	
	.text
	.align 2
	.globl main
	.globl _PrintInt
	.globl _PrintString
	.globl _PrintBool
	.globl _Alloc
	.globl _StringEqual
	.globl _Halt
	.globl _ReadInteger
	.globl _ReadLine
	
_PrintInt:
	subu $sp, $sp, 8	# decrement so to make space to save ra, fp
	sw $fp, 8($sp)  	# save fp
	sw $ra, 4($sp)  	# save ra
	addiu $fp, $sp, 8	# set up new fp
	li $v0, 1       	# system call code for print_int
	lw $a0, 4($fp)
	syscall
	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra
	
_PrintBool:
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 8
	lw $t1, 4($fp)
	blez $t1, fbr
	li $v0, 4       	# system call for print_str
	la $a0, TRUE
	syscall
	b end
fbr:
	li $v0, 4       	# system call for print_str
	la $a0, FALSE
	syscall
end:
	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra
	
_PrintString:
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 8
	li $v0, 4       	# system call for print_str
	lw $a0, 4($fp)
	syscall
	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra
	
_Alloc:
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 8
	li $v0, 9       	# system call for sbrk
	lw $a0, 4($fp)
	syscall
	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra
	
_StringEqual:
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 8
	subu $sp, $sp, 4	# decrement sp to make space for return value
	li $v0, 0
	#Determine length string 1
	lw $t0, 4($fp)
	li $t3, 0
bloop1:
	lb $t5, ($t0)
	beqz $t5, eloop1
	addi $t0, 1
	addi $t3, 1
	b bloop1
eloop1:
	#Determine length string 2
	lw $t1, 8($fp)
	li $t4, 0
bloop2:
	lb $t5, ($t1)
	beqz $t5, eloop2
	addi $t1, 1
	addi $t4, 1
	b bloop2
eloop2:
	bne $t3, $t4, end1	# check if string lengths are the same
	lw $t0, 4($fp)
	lw $t1, 8($fp)
	li $t3, 0
bloop3:
	lb $t5, ($t0)
	lb $t6, ($t1)
	bne $t5, $t6, end1
	addi $t3, 1
	addi $t0, 1
	addi $t1, 1
	bne $t3, $t4, bloop3
eloop3:
	li $v0, 1
end1:
	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra
	
_Halt:
	li $v0, 10
	syscall
	
_ReadInteger:
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 8
	subu $sp, $sp, 4
	li $v0, 5
	syscall
	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra
	
_ReadLine:
	subu $sp, $sp, 8
	sw $fp, 8($sp)
	sw $ra, 4($sp)
	addiu $fp, $sp, 8
	li $t0, 40
	subu $sp, $sp, 4
	sw $t0, 4($sp)
	jal _Alloc
	move $t0, $v0
	li $a1, 40
	move $a0, $t0
	li $v0, 8
	syscall
	move $t1, $t0
bloop4:
	lb $t5, ($t1)
	beqz $t5, eloop4
	addi $t1, 1
	b bloop4
eloop4:
	addi $t1, -1
	li $t6, 0
	sb $t6, ($t1)
	move $v0, $t0
	move $sp, $fp
	lw $ra, -4($fp)
	lw $fp, 0($fp)
	jr $ra
	
__foo:
	# BeginFunc 16
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 16	# decrement sp to make space for locals/temps
	# IfZ c Goto _L0
	lw $t0, 8($fp)	# load c from $fp+8 into $t0
	beqz $t0, _L0	# branch if c is zero 
	# _tmp0 = 2
	li $t0, 2		# load constant value 2 into $t0
	# _tmp1 = a + _tmp0
	lw $t1, 4($fp)	# load a from $fp+4 into $t1
	add $t2, $t1, $t0	
	# Return _tmp1
	move $v0, $t2		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# Goto _L1
	b _L1		# unconditional branch
_L0:
	# PushParam a
	subu $sp, $sp, 4	# decrement sp to make space for param
	lw $t0, 4($fp)	# load a from $fp+4 into $t0
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintInt
	jal _PrintInt      	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
	# _tmp2 = " wacky.\n"
	.data			# create string constant marked with label
	_string1: .asciiz " wacky.\n"
	.text
	la $t0, _string1	# load label
	# PushParam _tmp2
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# LCall _PrintString
	# (save modified registers before flow of control change)
	sw $t0, -16($fp)	# spill _tmp2 from $t0 to $fp-16
	jal _PrintString   	# jump to function
	# PopParams 4
	add $sp, $sp, 4	# pop params off stack
_L1:
	# _tmp3 = 18
	li $t0, 18		# load constant value 18 into $t0
	# Return _tmp3
	move $v0, $t0		# assign return value into $v0
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
main:
	# BeginFunc 84
	subu $sp, $sp, 8	# decrement sp to make space to save ra, fp
	sw $fp, 8($sp)	# save fp
	sw $ra, 4($sp)	# save ra
	addiu $fp, $sp, 8	# set up new fp
	subu $sp, $sp, 84	# decrement sp to make space for locals/temps
	# _tmp4 = 10
	li $t0, 10		# load constant value 10 into $t0
	# a = _tmp4
	move $t1, $t0		# copy value
	# _tmp5 = 2
	li $t2, 2		# load constant value 2 into $t2
	# _tmp6 = a / _tmp5
	div $t3, $t1, $t2	
	# b = _tmp6
	move $t4, $t3		# copy value
	# _tmp7 = 1
	li $t5, 1		# load constant value 1 into $t5
	# PushParam _tmp7
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# PushParam a
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t1, 4($sp)	# copy param value to stack
	# _tmp8 = LCall __foo
	# (save modified registers before flow of control change)
	sw $t0, -12($fp)	# spill _tmp4 from $t0 to $fp-12
	sw $t1, 0($gp)	# spill a from $t1 to $gp+0
	sw $t2, -20($fp)	# spill _tmp5 from $t2 to $fp-20
	sw $t3, -16($fp)	# spill _tmp6 from $t3 to $fp-16
	sw $t4, -8($fp)	# spill b from $t4 to $fp-8
	sw $t5, -24($fp)	# spill _tmp7 from $t5 to $fp-24
	jal __foo          	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp9 = a < b
	lw $t1, 0($gp)	# load a from $gp+0 into $t1
	lw $t2, -8($fp)	# load b from $fp-8 into $t2
	slt $t3, $t1, $t2	
	# _tmp10 = a == b
	seq $t4, $t1, $t2	
	# _tmp11 = _tmp9 || _tmp10
	or $t5, $t3, $t4	
	# PushParam _tmp11
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t5, 4($sp)	# copy param value to stack
	# _tmp12 = 2
	li $t6, 2		# load constant value 2 into $t6
	# _tmp13 = b + _tmp12
	add $t7, $t2, $t6	
	# PushParam _tmp13
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t7, 4($sp)	# copy param value to stack
	# _tmp14 = LCall __foo
	# (save modified registers before flow of control change)
	sw $t0, -28($fp)	# spill _tmp8 from $t0 to $fp-28
	sw $t3, -32($fp)	# spill _tmp9 from $t3 to $fp-32
	sw $t4, -36($fp)	# spill _tmp10 from $t4 to $fp-36
	sw $t5, -40($fp)	# spill _tmp11 from $t5 to $fp-40
	sw $t6, -48($fp)	# spill _tmp12 from $t6 to $fp-48
	sw $t7, -44($fp)	# spill _tmp13 from $t7 to $fp-44
	jal __foo          	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# _tmp15 = 1
	li $t1, 1		# load constant value 1 into $t1
	# _tmp16 = 1
	li $t2, 1		# load constant value 1 into $t2
	# _tmp17 = _tmp15 - _tmp16
	sub $t3, $t1, $t2	
	# PushParam _tmp17
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t3, 4($sp)	# copy param value to stack
	# _tmp18 = 0
	li $t4, 0		# load constant value 0 into $t4
	# _tmp19 = 1
	li $t5, 1		# load constant value 1 into $t5
	# _tmp20 = _tmp19 && _tmp18
	and $t6, $t5, $t4	
	# PushParam _tmp20
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t6, 4($sp)	# copy param value to stack
	# _tmp21 = 3
	li $t7, 3		# load constant value 3 into $t7
	# PushParam _tmp21
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t7, 4($sp)	# copy param value to stack
	# _tmp22 = LCall __foo
	# (save modified registers before flow of control change)
	sw $t0, -52($fp)	# spill _tmp14 from $t0 to $fp-52
	sw $t1, -56($fp)	# spill _tmp15 from $t1 to $fp-56
	sw $t2, -64($fp)	# spill _tmp16 from $t2 to $fp-64
	sw $t3, -60($fp)	# spill _tmp17 from $t3 to $fp-60
	sw $t4, -72($fp)	# spill _tmp18 from $t4 to $fp-72
	sw $t5, -76($fp)	# spill _tmp19 from $t5 to $fp-76
	sw $t6, -68($fp)	# spill _tmp20 from $t6 to $fp-68
	sw $t7, -80($fp)	# spill _tmp21 from $t7 to $fp-80
	jal __foo          	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# PushParam _tmp22
	subu $sp, $sp, 4	# decrement sp to make space for param
	sw $t0, 4($sp)	# copy param value to stack
	# _tmp23 = LCall __foo
	# (save modified registers before flow of control change)
	sw $t0, -84($fp)	# spill _tmp22 from $t0 to $fp-84
	jal __foo          	# jump to function
	move $t0, $v0		# copy function return value from $v0
	# PopParams 8
	add $sp, $sp, 8	# pop params off stack
	# EndFunc
	# (below handles reaching end of fn body with no explicit return)
	move $sp, $fp		# pop callee frame off stack
	lw $ra, -4($fp)	# restore saved ra
	lw $fp, 0($fp)	# restore saved fp
	jr $ra		# return from function
