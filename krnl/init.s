.globl krnl_init

.data

.text
krnl_init:
	# Reinitialize kernel stack location
	li $sp, 0xA0005000

	# Save the return location
	addi $sp, $sp, 0x4
	sw $ra, 0($sp)

	# Initialize the memory manager
	jal krnl_mm_init
	bne $v0, $zero, failed

	# Restore the return location
	lw $ra, 0($sp)
	addi $sp, $sp, -0x4

	# Create the system process
	j krnl_create_init_thread

failed:
	j failed # Loop forever
