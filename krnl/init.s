.globl krnl_init

.data

.text

#
# Kernel memory layout:
# 0x80000000 - 0x800000FF  Kernel context (reserved)
# 0x80000100 - 0x800002FF  Kernel stack
# 0x80000300 - 0x80000FFF  Region allocator zone
# 0x80001000 - 0x80007FFF  Simple Mm's allocator zone
#
# Kernel context (stored in $k0):
#
# 0x00 - Interrupt vector table
# 0x20 - Region allocator next pointer
# 0x24 - Region allocator upper bound
# 0x28 - Memory manager mutex (8 bytes)
# 0x30 - Memory manager next pointer
# 0x34 - Memory manager upper bound
# 0x38 - Mutex contention lock
# 0x3C - Syscall ordinal limit
# 0x40 - Syscall table
# 

# void krnl_init()
krnl_init:
	# Setup the kernel context
	lw $k0, KRNL_CONTEXT_ADDR

	# Setup init thread's stack (destroys existing stack but doesn't matter)
	lw $sp, KRNL_STACK_ADDR

	# Push the return address onto the new stack so it is saved until after thread creation
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Setup exception handling
	jal krnl_exception_init
	bne $v0, $zero, initfailed

	# Initialize the mutex contention lock
	addi $a0, $k0, 0x38
	jal krnl_spinlock_init

	# Initialize the early boot memory manager
	jal krnl_mmregion_init
	bne $v0, $zero, initfailed # Check for init failure

	# Create this CPU's PCR
	jal krnl_pcr_alloc
	beq $v0, $zero, initfailed # Check for init failure

	# Create the system init thread
	addi $a0, $v0, 0x0 # PCR is argument 0
	jal krnl_create_init_thread

	# Setup the CPU scheduler
	jal krnl_scheduler_init
	bne $v0, $zero, initfailed

	# Initialize the memory manager
	jal krnl_mm_init
	bne $v0, $zero, initfailed

	# Initialize the syscall table
	jal krnl_syscall_init

	# Restore the return location
	lw $ra, 0($sp)
	addi $sp, $sp, 0x4

	# Return to the idle thread
	jr $ra

initfailed:
	jal krnl_fubar # Panic
