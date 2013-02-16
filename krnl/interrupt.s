.globl krnl_disable_interrupts
.globl krnl_restore_interrupts

.data

.text

# int krnl_disable_interrupts()
krnl_disable_interrupts:
	# TODO: Implement me
	addi $v0, $zero, 0x0 # Return the interrupt state
	jr $ra # Return

# void krnl_restore_interrupts(int)
krnl_restore_interrupts:
	# TODO: Implement me
	jr $ra # Return
