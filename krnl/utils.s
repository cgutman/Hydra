.globl krnl_memcpy

.set noat

.data

.text
# void krnl_memcpy(void* dst, void* src, int size)
krnl_memcpy:
	# Branch if we can't copy a full word
	slti $t1, $a2, 0x4
	bne $t1, $zero, partialcopy

	# Copy a full word
	lw $t0, 0($a1)
	sw $t0, 0($a0)

	# Update the pointers and size
	addi $a0, $a0, 0x4 # dst
	addi $a1, $a1, 0x4 # src
	addi $a2, $a2, -0x4 # size

	# Branch if data still remains to be copied
	bne $a2, $zero, krnl_memcpy

	# All done
	jr $ra

partialcopy:
	# Copy on the byte level
	lb $t0, 0($a1)
	sb $t0, 0($a0)

	# Update the pointers and size
	addi $a0, $a0, 0x1
	addi $a1, $a1, 0x1
	addi $a2, $a2, -0x1

	# Branch if data still remains to be copied
	bne $a2, $zero, partialcopy

	# All done
	jr $ra
