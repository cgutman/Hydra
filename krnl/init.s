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
# HACK: UM hack in krnl_init and krnl_create_thread
#

# void krnl_init(void* startAddress)
krnl_init:
	# Setup init thread's stack (destroys existing stack but doesn't matter)
	lw $sp, KRNL_STACK_ADDR

	# Save starting address
	addi $sp, $sp, -0x4
	sw $a0, 0($sp)

	# Setup the kernel context
	lw $k0, KRNL_CONTEXT_ADDR

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

	# Create the system idle thread
	addi $a0, $v0, 0x0 # PCR is argument 0
	la $a1, krnl_idle
	jal krnl_create_idle_thread

	# We're impersonating the idle thread now

	# Setup the CPU scheduler
	jal krnl_scheduler_init
	bne $v0, $zero, initfailed

	# Initialize the memory manager
	jal krnl_mm_init
	bne $v0, $zero, initfailed

	# Initialize the syscall table
	jal krnl_syscall_init

	# Set the UM bit (although we remain in kernel-mode due to EXL)
	mfc0 $t0, $12
	#ori $t0, $t0, 0x10 # UM
	mtc0 $t0, $12
	ehb

	# Pop starting address for user-mode
	lw $a0, 0($sp)
	addi $sp, $sp, 0x4

	# Create the initial user-mode thread and start executing
	j krnl_create_initial_user_thread

initfailed:
	jal krnl_fubar # Panic
