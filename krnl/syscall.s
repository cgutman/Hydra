.globl krnl_syscall_dispatch

.data

.text
krnl_syscall_dispatch:
	# Save the return address
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)
	sw $sp, 0x198($k1) # Update kernel stack location

	# Enable interrupts
	ei

	# Restore the return address
	lw $ra, 0($sp)
	addi $sp, $sp, 0x4

	# Return to user-mode
	j krnl_return_to_epc_next
