.globl krnl_disable_interrupts
.globl krnl_restore_interrupts

.data

.text

# int krnl_disable_interrupts()
krnl_disable_interrupts:
	# Load the PCR
	addi $t0, $gp, 0x74
	lw $t0, 0($t0)

	# Load the old interrupt state into the return register
	addi $t0, $t0, 0x10
	lw $v0, 0($t0)

	# Disable interrupts
	sw $zero, 0($t0)

	# FIXME: Write the new state to hardware

	jr $ra # Return

# void krnl_restore_interrupts(int oldstate)
krnl_restore_interrupts:
	# Load the PCR
	addi $t0, $gp, 0x74
	lw $t0, 0($t0)

	# Write the old state back
	addi $t0, $t0, 0x10
	sw $a0, 0($t0)

	# FIXME: Write the new state to hardware

	jr $ra # Return
