.globl krnl_idle
.globl krnl_create_idle_thread

.data

.text
# void krnl_create_idle_thread(void* pcr, void* start)
krnl_create_idle_thread:
	# Save the starting address
	addi $s0, $a1, 0x0

	# Save the PCR address
	addi $s1, $a0, 0x0

	# Save the return address
	addi $s2, $ra, 0x0

	# Allocate the thread context (minus stack)
	li $a0, 0x19C
	jal krnl_mmregion_alloc
	beq $v0, $zero, initthreadfailed

	# Load the thread context
	addi $k1, $v0, 0x0

	# Write the PCR address
	sw $s1, 0x74($k1)

	# Final PCR setup
	sw $k1, 0x04($s1) # Current thread
	sw $k1, 0x0C($s1) # Idle thread

	# Write the starting address
	sw $s0, 0x80($k1)

	# Write the stack address (already setup)
	sw $sp, 0x64($k1)

	# Write the wait object pointer
	sw $zero, 0x78($k1)

	# Write the wait queue entry
	sw $zero, 0x7C($k1)

	# Write the next thread
	sw $zero, 0x70($k1)

	# No exception active
	sw $zero, 0x8C($k1)

	# Default TTY
	li $t0, 2
	sw $t0, 0x198($k1)

	# Return to init code
	addi $ra, $s2, 0x0
	jr $ra

initthreadfailed:
	jal krnl_fubar # Panic

# System idle thread
krnl_idle:

	# Just try to give up the CPU
	jal krnl_yield_thread

	j krnl_idle
