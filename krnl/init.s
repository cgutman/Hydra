.globl krnl_init

.data

.text

#
# Kernel memory layout:
# 0x80000000 - 0x80001FFF  Kernel region allocator zone (early-boot)
# 0x80002000               Simple Mm's mutex
# 0x80002008               Simple Mm's next pointer
# 0x8000200C - 0x80007FFF  Simple Mm's allocator zone
#

# void krnl_init()
krnl_init:
	# Save the return location (destroys $s0 but that doesn't matter)
	addi $s0, $ra, 0x0

	# Initialize the early boot memory manager
	jal krnl_mmregion_init

	# Allocate some stack for the initial system thread
	li $a0, 0x20 # 32 bytes should do
	jal krnl_mmregion_alloc
	beq $v0, $zero, initfailed # Check for allocation failure

	# Setup init thread's stack (destroys existing stack but doesn't matter)
	addi $sp, $v0, 0x0

	# Push the return address onto the new stack so it is saved until after thread creation
	addi $sp, $sp, 0x4
	sw $s0, 0($sp)

	# Create this CPU's PCR
	jal krnl_pcr_alloc
	beq $v0, $zero, initfailed # Check for init failure

	# Create the system init thread
	addi $a0, $v0, 0x0 # PCR is argument 0
	jal krnl_create_init_thread

	# Initialize the memory manager
	jal krnl_mm_init
	bne $v0, $zero, initfailed

	# Restore the return location
	lw $ra, 0($sp)
	addi $sp, $sp, -0x4

	# Return to the idle thread
	jr $ra

initfailed:
	jal krnl_fubar # Panic
