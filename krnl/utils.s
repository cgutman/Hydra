.globl memcmp
.globl memset
.globl memcpy
.globl strlen

# int strlen(char* str)
strlen:
	li $v0, 0x0

strlenloop:
	# Check this byte
	lbu $t0, 0($a0)
	beq $t0, $zero, strlendone

	# Next byte
	addi $a0, $a0, 0x1
	addi $v0, $v0, 0x1
	j strlenloop

strlendone:
	jr $ra

# int memcmp(char* buf1, char* buf2, int len)
memcmp:
	# Check if there are no bytes left
	beq $a2, $zero, memcmpequal

	# Check if the current bytes are equal
	lbu $t0, 0($a0)
	lbu $t1, 0($a1)
	sub $v0, $t1, $t0
	bne $v0, $zero, memcmpdiff

	# Call memcmp again
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	addi $a2, $a2, -1
	j memcmp

memcmpdiff:
	# These are not equal
	jr $ra

memcmpequal:
	# These are equal
	li $v0, 0x0
	jr $ra

# void memset(char* buf, char fill, int len)
memset:
	# Check if there are no bytes left
	beq $a2, $zero, memsetdone

	# Write the fill value to the current byte
	sb $a1, 0($a0)

	# Call memset again
	addi $a0, $a0, 1
	addi $a2, $a2, -1
	j memset

memsetdone:
	# Return
	jr $ra

# void memcpy(char* dst, char* src, int len)
memcpy:
	# Check if there are no bytes left
	beq $a2, $zero, memcpydone

	# Copy the byte
	lbu $t0, 0($a1)
	sb $t0, 0($a0)

	# Call memcpy again
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	addi $a2, $a2, -1
	j memcpy

memcpydone:
	# Return
	jr $ra
