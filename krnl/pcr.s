.globl krnl_pcr_alloc

.data

.text
#
# PCR structure:
# 0x00 CPU number
# 0x04 Current thread
# 0x08 First thread on run queue
# 0x0C Idle thread
# 0x10 Interrupt state
#

# void* krnl_pcr_alloc()
krnl_pcr_alloc:
	# Save the return address
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Allocate the PCR
	li $a0, 0x14
	jal krnl_mmregion_alloc
	beq $v0, $zero, cleanup # Check for alloc failure

	# Write the CPU number
	li $t0, 0x0 # FIXME: Hardcoded to CPU 0
	sw $t0, 0($v0)

	# Write this thread as the current thread and idle thread
	sw $k1, 0x04($v0)
	sw $k1, 0x0C($v0)

	# No running thread head right now
	sw $zero, 0x08($v0)

	# All interrupts are enabled
	li $t1, 0xFFFFFFFF
	sw $t1, 0x10($v0)

cleanup:
	# Restore the return address
	lw $ra, 0($sp)
	addi $sp, $sp, 0x4

	# Return
	jr $ra
