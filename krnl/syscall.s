.globl krnl_syscall_dispatch

.data

.text
krnl_syscall_dispatch:
	# Save the return address
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Enable interrupts by masking EXL
	mfc0 $t0, $12
	li $t1, 0xFFFFFFFD
	and $t0, $t0, $t1
	mtc0 $t0, $12
	ehb

	# TODO: Do stuff

	# Restore the return address
	lw $ra, 0($sp)
	addi $sp, $sp, 0x4

	# Return to user-mode
	j krnl_return_to_epc_next
