#---------------------------------------------------------------
# Assignment:           2
# Due Date:             October 5, 2016
# Name:                 Alden Tan
# Unix ID:              aet
# Lecture Section:      A1
# Instructor:           Jose Nelson Amaral
# Lab Section:          D03 (Wednesday 1400 - 1650)
# Teaching Assistant:   Wanxin Gao
#---------------------------------------------------------------

#---------------------------------------------------------------
# This is a subroutine that takes a branch instruction stored
# in the memory address $a0 and prints out the instruction fully
# in lowercase, prefixing registers with '$', seperating registers
# and addresses with a comma and a space, only including register
# $t if it is used in the branch, and printing the absolute
# address of the branch target, in 0xFFFFFFFF form.
#---------------------------------------------------------------

disassembleBranch:

	#place the address in $t7
	add $t7 $zero $a0
	
	#load the assembly instruction into $t6
	lw $t6 0($a0)

	#make mask to copy the opcode
	lui $t0 0xFF00
	sll $t0 $t0 2
	
	#copying
	and $t1 $t0 $t6
	srl $t1 $t1 26
	#$t1 now contains the opcode

	#make mask to copy S Register
	lui $t0 0xFF00
	sll $t0 $t0 3
	srl $t0 $t0 6

	#copying
	and $t2 $t0 $t6
	srl $t2 $t2 21
	#$t2 now contains the S Register

	#make mask to copy T Register
	lui $t0 0x001F
	
	#copying
	and $t3 $t0 $t6
	srl $t3 $t3 16
	#$t3 now contains the T Register
	
	#make mask to copy Branch Offset
	lui $t0 0xFFFF
	srl $t0 $t0 16	

	#copying
	and $t4 $t0 $t6
	sll $t4 $t4 16
	sra $t4 $t4 16
	#$t4 now contains the Branch Offset

	#check if bgez, bgezal, bltz or bltzal
	addi $t0 $zero 1
	beq $t1 $t0 OPCODECHECK
	
	#check if beq,bne, blez or bgtz
	addi $t0 $zero 4
	beq $t1 $t0 BEQPRINT

	addi $t0 $zero 5
	beq $t1 $t0 BNEPRINT

	addi $t0 $zero 6 
	beq $t1 $t0 BLEZPRINT

	addi $t0 $zero 7
	beq $t1 $t0 BGTZPRINT

	j END

BEQPRINT:
	
	#print "beq "
	li $v0 11
	addi $a0 $zero 98
	syscall
	
	addi $a0 $zero 101
	syscall
	
	addi $a0 $zero 113
	syscall

	addi $a0 $zero 32
	syscall

	j OPCODEDONE

BNEPRINT:
	
	#print "bne "
	li $v0 11
	addi $a0 $zero 98
	syscall
	
	addi $a0 $zero 110
	syscall
	
	addi $a0 $zero 101
	syscall

	addi $a0 $zero 32
	syscall

	j OPCODEDONE

BLEZPRINT:
	
	#print "blez "
	li $v0 11
	addi $a0 $zero 98
	syscall
	
	addi $a0 $zero 108
	syscall
	
	addi $a0 $zero 101
	syscall

	addi $a0 $zero 122
	syscall

	addi $a0 $zero 32
	syscall

	j OPCODEDONE

BGTZPRINT:
	
	#print "bgtz "
	li $v0 11
	addi $a0 $zero 98
	syscall
	
	addi $a0 $zero 103
	syscall
	
	addi $a0 $zero 116
	syscall

	addi $a0 $zero 122
	syscall

	addi $a0 $zero 32
	syscall

	j OPCODEDONE

OPCODECHECK:
	
	#Check which branch instruction
	addi $t0 $zero 1
	beq $t3 $t0 BGEZPRINT

	addi $t0 $zero 17
	beq $t3 $t0 BGEZALPRINT
	
	addi $t0 $zero 0
	beq $t3 $t0 BLTZPRINT

	addi $t0 $zero 16
	beq $t3 $t0 BLTZALPRINT

BGEZPRINT:
	
	#print "bgez "
	li $v0 11
	addi $a0 $zero 98
	syscall
	
	addi $a0 $zero 103
	syscall
	
	addi $a0 $zero 101
	syscall

	addi $a0 $zero 122
	syscall

	addi $a0 $zero 32
	syscall

	j OPCODEDONE

BGEZALPRINT:
	
	#print "bgezal "
	li $v0 11
	addi $a0 $zero 98
	syscall
	
	addi $a0 $zero 103
	syscall
	
	addi $a0 $zero 101
	syscall

	addi $a0 $zero 122
	syscall

	addi $a0 $zero 97
	syscall
	
	addi $a0 $zero 108
	syscall

	addi $a0 $zero 32
	syscall

	j OPCODEDONE

BLTZPRINT:
	
	#print "bltz "
	li $v0 11
	addi $a0 $zero 98
	syscall
	
	addi $a0 $zero 108
	syscall
	
	addi $a0 $zero 116
	syscall

	addi $a0 $zero 122
	syscall

	addi $a0 $zero 32
	syscall

	j OPCODEDONE
	
BLTZALPRINT:
	
	#print "bltzal "
	li $v0 11
	addi $a0 $zero 98
	syscall
	
	addi $a0 $zero 108
	syscall
	
	addi $a0 $zero 116
	syscall

	addi $a0 $zero 122
	syscall

	addi $a0 $zero 97
	syscall

	addi $a0 $zero 108
	syscall

	addi $a0 $zero 32
	syscall
	
	j OPCODEDONE

OPCODEDONE:

	#now we print the S Register
	li $v0 11
	addi $a0 $zero 36
	syscall
	
	li $v0 1
	add $a0 $zero $t2
	syscall

	li $v0 11
	addi $a0 $zero 44
	syscall

	li $v0 11
	addi $a0 $zero 32
	syscall

	#checking whether there is a T Register
	addi $t0 $zero 4
	beq $t1 $t0 TPRINT

	addi $t0 $zero 5
	beq $t1 $t0 TPRINT
	
	j OFFSETCHECK

TPRINT:

	#print the T Register
	li $v0 11
	addi $a0 $zero 36
	syscall
	
	li $v0 1
	add $a0 $zero $t3
	syscall

	li $v0 11
	addi $a0 $zero 44
	syscall

	li $v0 11
	addi $a0 $zero 32
	syscall

OFFSETCHECK:
	
	#getting the absolute address of the branch target
	sll $t0 $t4 2
	add $t0 $t0 $t7

	#$t5 contains the absolute address of the branch target
	addi $t5 $t0 4

	#now we print the absolute address of the branch target
	li $v0 1	
	addi $a0 $zero 0
	syscall
	
	li $v0 11
	addi $a0 $zero 120
	syscall

	addi $t1 $zero -4
	addi $t2 $zero 9

	#counter
	addi $t3 $zero 0
	#limit
	addi $t4 $zero 8

LOOP:
	beq $t3 $t4 END
	addi $t3 $t3 1
	addi $t1 $t1 4
	
	sll $a0 $t5 $t1
	srl $a0 $a0 28
	bgt $a0 $t2 ADD87

	li $v0 1
	syscall

	j LOOP

ADD87:
	addi $a0 $a0 87
	
	li $v0 11
	syscall

	j LOOP

END:
	jr $ra
	


	



