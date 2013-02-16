.globl krnl_create_thread
.globl krnl_sleep_thread
.globl krnl_create_init_thread

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
# 0x8C Stack
# 0x100 Next thread in wait entry
# 0x104 End
#
# PCR structure:
# 0x00 CPU number
# 0x04 Current thread
# 0x08 First thread on run queue
# 0x0C Idle thread
#

# void krnl_create_init_thread()
krnl_create_init_thread:
	# Save the starting address
	addi $s0, $ra, 0x0

	# Allocate the thread context
	li $a0, 0x104
	jal krnl_paged_alloc

	# Load the thread context
	addi $gp, $v0, 0x0

	# Allocate the PCR
	li $a0, 0x10
	jal krnl_paged_alloc

	# Write the PCR address
	li $t0, 0x74
	add $t0, $t0, $gp
	sw $v0, 0($t0)

	# Initialize the PCR

	# Write the CPU number
	li $t0, 0x0 # FIXME: Hardcoded to CPU 0
	sw $t0, 0($v0)

	# Write this thread as the current thread and idle thread
	li $t0, 0x4
	add $t0, $v0, $t0
	sw $gp, 0($t0)
	sw $gp, 8($t0)

	# No running thread head right now
	li $t1, 0x0
	sw $t1, 4($t0)

	# Write the starting address
	li $t0, 0x6C
	add $t0, $t0, $gp
	sw $s0, 0($t0)

	# Write the stack address
	li $t0, 0x8C
	add $t1, $t0, $gp
	li $t0, 0x64
	add $t0, $t0, $gp
	sw $t1, 0($t0)

	# Write the wait object pointer
	li $t0, 0x0
	li $t1, 0x78
	add $t1, $t1, $gp
	sw $t0, 0($t1)

	# Write the wait queue entry
	li $t0, 0x0
	li $t1, 0x100
	add $t1, $t1, $gp
	sw $t0, 0($t1)

	# Write the next thread
	li $t0, 0x0
	li $t1, 0x70
	add $t1, $t1, $gp
	sw $t0, 0($t1)

	# Unfreeze the thread
	jal krnl_unfreeze_thread

# void krnl_create_thread(void* starting_address)
krnl_create_thread:

	# Save the assembler temp
	sw $at, 0($gp)

	# Save v0 so we can (ab)use it for tracking which register we're on
	sw $v0, 4($gp)
	addi $v0, $gp, 0x8

	# Save v1
	sw $v1, 0($v0)
	addi $v0, $v0, 0x4

	# Save a0 - a3
	sw $a0, 0($v0)
	addi $v0, $v0, 0x4
	sw $a1, 0($v0)
	addi $v0, $v0, 0x4
	sw $a2, 0($v0)
	addi $v0, $v0, 0x4
	sw $a3, 0($v0)
	addi $v0, $v0, 0x4

	# Save t0 - t7
	sw $t0, 0($v0)
	addi $v0, $v0, 0x4
	sw $t1, 0($v0)
	addi $v0, $v0, 0x4
	sw $t2, 0($v0)
	addi $v0, $v0, 0x4
	sw $t3, 0($v0)
	addi $v0, $v0, 0x4
	sw $t4, 0($v0)
	addi $v0, $v0, 0x4
	sw $t5, 0($v0)
	addi $v0, $v0, 0x4
	sw $t6, 0($v0)
	addi $v0, $v0, 0x4
	sw $t7, 0($v0)
	addi $v0, $v0, 0x4

	# Save s0 - s7
	sw $s0, 0($v0)
	addi $v0, $v0, 0x4
	sw $s1, 0($v0)
	addi $v0, $v0, 0x4
	sw $s2, 0($v0)
	addi $v0, $v0, 0x4
	sw $s3, 0($v0)
	addi $v0, $v0, 0x4
	sw $s4, 0($v0)
	addi $v0, $v0, 0x4
	sw $s5, 0($v0)
	addi $v0, $v0, 0x4
	sw $s6, 0($v0)
	addi $v0, $v0, 0x4
	sw $s7, 0($v0)
	addi $v0, $v0, 0x4

	# Save t8 - t9
	sw $t8, 0($v0)
	addi $v0, $v0, 0x4
	sw $t9, 0($v0)
	addi $v0, $v0, 0x4

	# Save stack pointer
	sw $sp, 0($v0)
	addi $v0, $v0, 0x4

	# Save the frame pointer
	sw $fp, 0($v0)
	addi $v0, $v0, 0x4

	# Save the return address
	sw $ra, 0($v0)
	addi $v0, $v0, 0x4

	# Save the starting address
	addi $s0, $a0, 0x0

	# Allocate the thread context
	li $a0, 0x104
	jal krnl_paged_alloc

	# Save the old thread
	addi $t2, $gp, 0x0

	# Read the PCR address from the old thread
	li $t0, 0x74
	add $t0, $t0, $gp
	lw $t1, 0($t0)

	# Load the thread context
	addi $gp, $v0, 0x0

	# Restore the PCR address pointer
	li $t0, 0x74
	add $t0, $t0, $gp
	sw $t1, 0($t0)

	# Link us into the list

	addi $t0, $t1, 0x08
	lw $t2, 0($t0) # Load the current head in $t2

	addi $t3, $gp, 0x70
	sw $t2, 0($t3) # Store the current head into the next thread entry

	sw $gp, 0($t0) # Store the current thread into the PCR's thread list head

	# Write the starting address
	li $t0, 0x6C
	add $t0, $t0, $gp
	sw $s0, 0($t0)

	# Write the stack address
	li $t0, 0x8C
	add $t1, $t0, $gp
	li $t0, 0x64
	add $t0, $t0, $gp
	sw $t1, 0($t0)

	# Write the wait object pointer
	li $t0, 0x0
	li $t1, 0x78
	add $t1, $t1, $gp
	sw $t0, 0($t1)

	# Write the wait queue entry
	li $t0, 0x0
	li $t1, 0x100
	add $t1, $t1, $gp
	sw $t0, 0($t1)

	# Unfreeze the thread
	jal krnl_unfreeze_thread

krnl_schedule_new_thread:
	# Get the current thread
	addi $t0, $gp, 0x0

	# No cycle yet
	addi $t5, $zero, 0x0

schedloop:
	# Get the next thread
	addi $t0, $t0, 0x70
	lw $t0, 0($t0)

	# Check if this is the last thread
	beq $t0, $zero, cyclethreads
	j testforblocked

cyclethreads:
	# Load the PCR
	addi $t3, $gp, 0x74
	lw $t4, 0($t3)

	# Check if we've already cycled
	bne $t5, $zero, idle

	# Grab the head of the list
	addi $t4, $t4, 0x8
	lw $t0, 0($t4)

	# Store that we've cycled before
	addi $t5, $zero, 0x1

testforblocked:
	# Check if the thread is blocked
	addi $t1, $t0, 0x78
	lw $t2, 0($t1)
	bne $t2, $zero, schedloop

	# Switch to new thread
	addi $gp, $t0, 0x0

	# Resume it
	j krnl_unfreeze_thread

idle:
	# Load the idle thread (PCR is in $t4)
	addi $t4, $t4, 0x0C
	lw $gp, 0($t4)

	# Unfreeze the idle thread
	j krnl_unfreeze_thread

krnl_sleep_thread:
	# Save the assembler temp
	sw $at, 0($gp)

	# Save v0 so we can (ab)use it for tracking which register we're on
	sw $v0, 4($gp)
	addi $v0, $gp, 0x8

	# Save v1
	sw $v1, 0($v0)
	addi $v0, $v0, 0x4

	# Save a0 - a3
	sw $a0, 0($v0)
	addi $v0, $v0, 0x4
	sw $a1, 0($v0)
	addi $v0, $v0, 0x4
	sw $a2, 0($v0)
	addi $v0, $v0, 0x4
	sw $a3, 0($v0)
	addi $v0, $v0, 0x4

	# Save t0 - t7
	sw $t0, 0($v0)
	addi $v0, $v0, 0x4
	sw $t1, 0($v0)
	addi $v0, $v0, 0x4
	sw $t2, 0($v0)
	addi $v0, $v0, 0x4
	sw $t3, 0($v0)
	addi $v0, $v0, 0x4
	sw $t4, 0($v0)
	addi $v0, $v0, 0x4
	sw $t5, 0($v0)
	addi $v0, $v0, 0x4
	sw $t6, 0($v0)
	addi $v0, $v0, 0x4
	sw $t7, 0($v0)
	addi $v0, $v0, 0x4

	# Save s0 - s7
	sw $s0, 0($v0)
	addi $v0, $v0, 0x4
	sw $s1, 0($v0)
	addi $v0, $v0, 0x4
	sw $s2, 0($v0)
	addi $v0, $v0, 0x4
	sw $s3, 0($v0)
	addi $v0, $v0, 0x4
	sw $s4, 0($v0)
	addi $v0, $v0, 0x4
	sw $s5, 0($v0)
	addi $v0, $v0, 0x4
	sw $s6, 0($v0)
	addi $v0, $v0, 0x4
	sw $s7, 0($v0)
	addi $v0, $v0, 0x4

	# Save t8 - t9
	sw $t8, 0($v0)
	addi $v0, $v0, 0x4
	sw $t9, 0($v0)
	addi $v0, $v0, 0x4

	# Save stack pointer
	sw $sp, 0($v0)
	addi $v0, $v0, 0x4

	# Save the frame pointer
	sw $fp, 0($v0)
	addi $v0, $v0, 0x4

	# Save the return address
	sw $ra, 0($v0)
	addi $v0, $v0, 0x4

	# ----------- We are no longer in the context of that thread ----------

	jal krnl_schedule_new_thread

krnl_unfreeze_thread:
	# Restore v1
	lw $v1, 8($gp)
	addi $v0, $gp, 0xC

	# Restore a0 - a3
	lw $a0, 0($v0)
	addi $v0, $v0, 0x4
	lw $a1, 0($v0)
	addi $v0, $v0, 0x4
	lw $a2, 0($v0)
	addi $v0, $v0, 0x4
	lw $a3, 0($v0)
	addi $v0, $v0, 0x4

	# Restore t0 - t7
	lw $t0, 0($v0)
	addi $v0, $v0, 0x4
	lw $t1, 0($v0)
	addi $v0, $v0, 0x4
	lw $t2, 0($v0)
	addi $v0, $v0, 0x4
	lw $t3, 0($v0)
	addi $v0, $v0, 0x4
	lw $t4, 0($v0)
	addi $v0, $v0, 0x4
	lw $t5, 0($v0)
	addi $v0, $v0, 0x4
	lw $t6, 0($v0)
	addi $v0, $v0, 0x4
	lw $t7, 0($v0)
	addi $v0, $v0, 0x4

	# Restore s0 - s7
	lw $s0, 0($v0)
	addi $v0, $v0, 0x4
	lw $s1, 0($v0)
	addi $v0, $v0, 0x4
	lw $s2, 0($v0)
	addi $v0, $v0, 0x4
	lw $s3, 0($v0)
	addi $v0, $v0, 0x4
	lw $s4, 0($v0)
	addi $v0, $v0, 0x4
	lw $s5, 0($v0)
	addi $v0, $v0, 0x4
	lw $s6, 0($v0)
	addi $v0, $v0, 0x4
	lw $s7, 0($v0)
	addi $v0, $v0, 0x4

	# Restore t8 - t9
	lw $t8, 0($v0)
	addi $v0, $v0, 0x4
	lw $t9, 0($v0)
	addi $v0, $v0, 0x4

	# Restore stack pointer
	lw $sp, 0($v0)
	addi $v0, $v0, 0x4

	# Restore the frame pointer
	lw $fp, 0($v0)
	addi $v0, $v0, 0x4

	# Restore the return address
	lw $ra, 0($v0)
	addi $v0, $v0, 0x4

	# Restore the assembler temp
	lw $at, 0($gp)

	# Restore v0 last
	lw $v0, 4($gp)

	# HACK: Restart execution
	jr $ra
