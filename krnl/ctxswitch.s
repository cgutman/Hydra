.globl krnl_create_thread
.globl krnl_sleep_thread
.globl krnl_create_init_thread
.globl krnl_scheduler_init

.set noat # $at can't be used here because we have to save it

.data

.text

# $gp is the thread context pointer (for now)
#
# Thread context structure:
# 0x00 $at
# 0x04 $v0 - $v1
# 0x0C $a0 - $a3
# 0x1C $t0 - $t7
# 0x3C $s0 - $s7
# 0x5C $t8 - $t9
# 0x64 $sp
# 0x68 $fp
# 0x6C $ra
# 0x70 Next thread on run queue
# 0x74 PCR pointer
# 0x78 Wait object pointer
# 0x7C Next thread in wait entry
# 0x80 Thread PC
# 0x84 End of stack
# 0x184 Beginning of stack
#

# int krnl_scheduler_init()
krnl_scheduler_init:
	# Save the return address
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Query the timer interrupt for this platform
	jal hal_get_timer_irq

	# Register for the timer interrupt
	addi $a0, $v0, 0x0
	la $a1, krnl_scheduler_timer
	jal krnl_register_interrupt

	# Start the timer
	li $a0, 0x1000
	jal hal_enable_timer

	# Restore the return address
	lw $ra, 0($sp)
	addi $sp, $sp, 0x4

	# Success
	li $v0, 0x0
	jr $ra

# void krnl_scheduler_timer()
# Only t0, t1, t2, and a0 are available
krnl_scheduler_timer:
	# Return address is the EPC
	mfc0 $t0, $14
	sw $t0, 0x80($k1)

	# Reset the interrupt
	jal hal_clear_timer_interrupt

	# Pop saved variables off the stack before freezing
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $a0, 12($sp)
	addi $sp, $sp, 0x10

	# Trigger the scheduler
	j krnl_freeze_thread

# void krnl_create_init_thread(void* pcr)
krnl_create_init_thread:
	# Save the starting address
	addi $s0, $ra, 0x0

	# Save the PCR address
	addi $s1, $a0, 0x0

	# Allocate the thread context (minus stack)
	li $a0, 0x84
	jal krnl_mmregion_alloc
	beq $v0, $zero, initthreadfailed

	# Load the thread context
	addi $k1, $v0, 0x0

	# Write the PCR address
	sw $s1, 0x74($k1)

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

	# Unfreeze the thread
	jal krnl_unfreeze_thread

initthreadfailed:
	jal krnl_fubar # Panic

# void krnl_create_thread(void* starting_address, void* arg0, void* arg1, void* arg2)
#
# Arg0 to Arg3 are optional
#
krnl_create_thread:

	# Save the assembler temp
	sw $at, 0x00($k1)

	# Save v0 - v1
	sw $v0, 0x04($k1)
	sw $v1, 0x08($k1)

	# Save a0 - a3
	sw $a0, 0x0C($k1)
	sw $a1, 0x10($k1)
	sw $a2, 0x14($k1)
	sw $a3, 0x18($k1)

	# Save t0 - t7
	sw $t0, 0x1C($k1)
	sw $t1, 0x20($k1)
	sw $t2, 0x24($k1)
	sw $t3, 0x28($k1)
	sw $t4, 0x2C($k1)
	sw $t5, 0x30($k1)
	sw $t6, 0x34($k1)
	sw $t7, 0x38($k1)

	# Save s0 - s7
	sw $s0, 0x3C($k1)
	sw $s1, 0x40($k1)
	sw $s2, 0x44($k1)
	sw $s3, 0x48($k1)
	sw $s4, 0x4C($k1)
	sw $s5, 0x50($k1)
	sw $s6, 0x54($k1)
	sw $s7, 0x58($k1)

	# Save t8 - t9
	sw $t8, 0x5C($k1)
	sw $t9, 0x60($k1)

	# Save stack pointer
	sw $sp, 0x64($k1)

	# Save the frame pointer
	sw $fp, 0x68($k1)

	# Save the return address
	sw $ra, 0x6C($k1)

	# The PC is the return address
	sw $ra, 0x80($k1)

	# Save the parameters
	addi $s0, $a0, 0x0
	addi $s1, $a1, 0x0
	addi $s2, $a2, 0x0
	addi $s3, $a3, 0x0

	# Allocate the thread context
	li $a0, 0x184
	jal krnl_paged_alloc

	# Save the old thread
	addi $t2, $k1, 0x0

	# Read the PCR address from the old thread
	lw $t1, 0x74($k1)

	# Load the thread context
	addi $k1, $v0, 0x0

	# Restore the PCR address pointer
	sw $t1, 0x74($k1)

	# Link us into the list
	lw $t2, 0x08($t1) # Load the current head in $t2
	sw $t2, 0x70($k1) # Store the current head into the next thread entry
	sw $k1, 0x08($t1) # Store the current thread into the PCR's thread list head

	# Write arguments into the new thread
	sw $s1, 0x0C($k1)
	sw $s2, 0x10($k1)
	sw $s3, 0x14($k1)

	# Write the starting address
	sw $s0, 0x80($k1)

	# Write the stack address
	addi $t1, $k1, 0x184
	sw $t1, 0x64($k1)

	# Write the wait object pointer
	sw $zero, 0x78($k1)

	# Write the wait queue entry
	sw $zero, 0x7C($k1)

	# Unfreeze the thread
	jal krnl_unfreeze_thread

krnl_schedule_new_thread:
	# Get the current thread
	addi $t0, $k1, 0x0

	# No cycle yet
	addi $t5, $zero, 0x0

schedloop:
	# Get the next thread
	lw $t0, 0x70($t0)

	# Check if this is the last thread
	bne $t0, $zero, testforblocked

cyclethreads:
	# Load the PCR
	lw $t4, 0x74($k1)

	# Check if we've already cycled
	bne $t5, $zero, idle

	# Grab the head of the list
	lw $t0, 0x8($t4)

	# Store that we've cycled before
	addi $t5, $zero, 0x1

	# If there are no other threads, idle
	beq $t0, $zero, idle

testforblocked:
	# Check if the thread is blocked
	lw $t2, 0x78($t0)
	bne $t2, $zero, schedloop

	# Switch to new thread
	addi $k1, $t0, 0x0

	# Resume it
	j krnl_unfreeze_thread

idle:
	# Load the idle thread (PCR is in $t4)
	lw $k1, 0x0C($t4)

	# Unfreeze the idle thread
	j krnl_unfreeze_thread

krnl_freeze_thread:
	# Save the assembler temp
	sw $at, 0x00($k1)

	# Save v0 - v1
	sw $v0, 0x04($k1)
	sw $v1, 0x08($k1)

	# Save a0 - a3
	sw $a0, 0x0C($k1)
	sw $a1, 0x10($k1)
	sw $a2, 0x14($k1)
	sw $a3, 0x18($k1)

	# Save t0 - t7
	sw $t0, 0x1C($k1)
	sw $t1, 0x20($k1)
	sw $t2, 0x24($k1)
	sw $t3, 0x28($k1)
	sw $t4, 0x2C($k1)
	sw $t5, 0x30($k1)
	sw $t6, 0x34($k1)
	sw $t7, 0x38($k1)

	# Save s0 - s7
	sw $s0, 0x3C($k1)
	sw $s1, 0x40($k1)
	sw $s2, 0x44($k1)
	sw $s3, 0x48($k1)
	sw $s4, 0x4C($k1)
	sw $s5, 0x50($k1)
	sw $s6, 0x54($k1)
	sw $s7, 0x58($k1)

	# Save t8 - t9
	sw $t8, 0x5C($k1)
	sw $t9, 0x60($k1)

	# Save stack pointer
	sw $sp, 0x64($k1)

	# Save the frame pointer
	sw $fp, 0x68($k1)

	# Save the return address
	sw $ra, 0x6C($k1)

	# ----------- We are no longer in the context of that thread ----------

	jal krnl_schedule_new_thread

krnl_sleep_thread:
	# Return address is the PC
	sw $ra, 0x80($k1)

	# Freeze the thread
	j krnl_freeze_thread

krnl_unfreeze_thread:
	# Write the old PC to EPC for eret
	lw $t0, 0x80($k1)
	mtc0 $t0, $14

	# Restore at
	lw $at, 0x00($k1)

	# Restore v0 - v1
	lw $v0, 0x04($k1)
	lw $v1, 0x08($k1)

	# Restore a0 - a3
	lw $a0, 0x0C($k1)
	lw $a1, 0x10($k1)
	lw $a2, 0x14($k1)
	lw $a3, 0x18($k1)

	# Restore t0 - t7
	lw $t0, 0x1C($k1)
	lw $t1, 0x20($k1)
	lw $t2, 0x24($k1)
	lw $t3, 0x28($k1)
	lw $t4, 0x2C($k1)
	lw $t5, 0x30($k1)
	lw $t6, 0x34($k1)
	lw $t7, 0x38($k1)

	# Restore s0 - s7
	lw $s0, 0x3C($k1)
	lw $s1, 0x40($k1)
	lw $s2, 0x44($k1)
	lw $s3, 0x48($k1)
	lw $s4, 0x4C($k1)
	lw $s5, 0x50($k1)
	lw $s6, 0x54($k1)
	lw $s7, 0x58($k1)

	# Restore t8 - t9
	lw $t8, 0x5C($k1)
	lw $t9, 0x60($k1)

	# Restore stack pointer
	lw $sp, 0x64($k1)

	# Restore the frame pointer
	lw $fp, 0x68($k1)

	# Restore the return address
	lw $ra, 0x6C($k1)

	# Return to the old PC
	eret
