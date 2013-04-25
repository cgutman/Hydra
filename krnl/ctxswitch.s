.globl krnl_create_thread
.globl krnl_yield_thread
.globl krnl_scheduler_init
.globl krnl_create_initial_user_thread
.globl krnl_user_thread_exception
.globl krnl_terminate_thread
.globl krnl_wait_for_thread

.set noat # $at can't be used here because we have to save it

.data
term_msg:
.asciiz "Scheduler: Current thread killed due to unhandled exception\r\n"

graceful_term_msg:
.asciiz "Scheduler: Current thread is exiting\r\n"

new_thread_msg:
.asciiz "Scheduler: Created a new thread\r\n"

.text

# $k1 is the thread context pointer
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
# 0x84 HI register
# 0x88 LO register
# 0x8C Exception active
# 0x90 End of kernel-mode thread stack
# 0x190 Beginning of kernel-mode thread stack
# 0x194 Saved user-mode stack pointer
# 0x198 I/O identifier
# 0x19C End of user-mode stack
# 0x119C Beginning of user-mode stack
# 0x11A0 Start of file table
# 0x11C0 End of file table
#

# int krnl_scheduler_init()
krnl_scheduler_init:
	# Save the return address
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Query the timer interrupt for this platform
	jal hal_get_timer_irq

	# Register the timer interrupt
	addi $a0, $v0, 0x0
	la $a1, krnl_scheduler_timer
	jal krnl_register_interrupt

	# Start the timer
	li $a0, 0x2000
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
	# Save the return address to stack
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Return address is the EPC
	lw $t0, 20($sp)
	sw $t0, 0x80($k1)

	# Reset the interrupt
	jal hal_clear_timer_interrupt

	# Check if this is a nested exception
	addi $t0, $sp, 0x1C
	addi $t1, $k1, 0x190
	bne $t1, $t0, nestedexcret

	# Unset exception active
	sw $zero, 0x8C($k1)

	# Pop saved variables off the stack before freezing
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $a0, 16($sp)
	lw $k0, 24($sp)
	addi $sp, $sp, 0x1C

	# Write the old status value back
	ori $k0, $k0, 0x2 # EXL bit is set
	mtc0 $k0, $12
	ehb

	# Switch back to user-mode thread stack
	lw $sp, 0x194($k1)

	# Restore k0
	lw $k0, KRNL_CONTEXT_ADDR

	# Trigger the scheduler
	j krnl_freeze_thread

nestedexcret:
	# Pop saved variables off the stack before freezing
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	lw $a0, 16($sp)
	lw $k0, 24($sp)
	addi $sp, $sp, 0x1C

	# Trigger the scheduler
	j krnl_freeze_thread

# void* krnl_create_thread(void* starting_address, void* arg0, void* arg1, void* arg2)
#
# Arg0 to Arg3 are optional
#
krnl_create_thread:

	# Disable interrupts and set UM again
	mfc0 $k0, $12
	ori $k0, $k0, 0x02 # UM, EXL
	mtc0 $k0, $12
	lw $k0, KRNL_CONTEXT_ADDR

	# Save the assembler temp
	sw $at, 0x00($k1)

	# Save v1 (v0 is overwritten by the pointer to the new thread)
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

	# Save HI and LO
	mfhi $t0
	mflo $t1
	sw $t0, 0x84($k1)
	sw $t1, 0x88($k1)

	# The PC is the return address
	sw $ra, 0x80($k1)

	# Save the parameters
	addi $s0, $a0, 0x0
	addi $s1, $a1, 0x0
	addi $s2, $a2, 0x0
	addi $s3, $a3, 0x0

	# Print a debug message
	la $a0, new_thread_msg
	jal krnl_debug

	# Allocate the thread context
	li $a0, 0x11C0
	jal krnl_paged_alloc

	# Zero the thread context
	addi $a0, $v0, 0x0
	li $a1, 0x00
	li $a2, 0x11C0
	jal memset

	# Write the new thread pointer to v0 to be returned
	sw $v0, 0x04($k1)

	# Save the old thread
	addi $t3, $k1, 0x0

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

	# Use the current TTY for the new thread
	lw $t1, 0x198($t3)
	sw $t1, 0x198($k1)

	# Write arguments into the new thread
	sw $s1, 0x0C($k1)
	sw $s2, 0x10($k1)
	sw $s3, 0x14($k1)

	# Write the starting address
	sw $s0, 0x80($k1)

	# Write the stack address
	addi $t1, $k1, 0x119C
	sw $t1, 0x64($k1)

	# Write the wait object pointer
	sw $zero, 0x78($k1)

	# Write the wait queue entry
	sw $zero, 0x7C($k1)

	# No exception active
	sw $zero, 0x8C($k1)

	# Unfreeze the thread
	j krnl_unfreeze_thread

# void krnl_create_initial_user_thread(void* start)
krnl_create_initial_user_thread:
	# Save the starting address
	addi $s0, $a0, 0x0

	# Allocate the thread context
	li $a0, 0x11C0
	jal krnl_paged_alloc

	# Zero the thread context
	addi $a0, $v0, 0x0
	li $a1, 0x00
	li $a2, 0x11C0
	jal memset

	# Save the old thread
	addi $t3, $k1, 0x0

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

	# Use the current TTY for the new thread
	lw $t1, 0x198($t3)
	sw $t1, 0x198($k1)

	# Write the starting address
	sw $s0, 0x80($k1)

	# Write the stack address
	addi $t1, $k1, 0x119C
	sw $t1, 0x64($k1)

	# Write the wait object pointer
	sw $zero, 0x78($k1)

	# Write the wait queue entry
	sw $zero, 0x7C($k1)

	# No exception active
	sw $zero, 0x8C($k1)

	# Unfreeze the thread
	j krnl_unfreeze_thread

# void krnl_wait_for_thread(void* thread)
krnl_wait_for_thread:
	# Save the return address and s0
	addi $sp, $sp, -0x8
	sw $ra, 0($sp)
	sw $s0, 4($sp)

	# Save the parameter
	addi $s0, $a0, 0x0

	# Acquire the dispatcher lock
	addi $a0, $k0, 0x38
	jal krnl_spinlock_acquire

	# Check if this thread is already dead
	lw $t0, 0x74($k1) # Get PCR from the current thread
	lw $t0, 0x08($t0) # Get the thread head from the PCR
waitthreadloop:
	# Check if the list has terminated
	beq $t0, $zero, waitthreadnotfound

	# Check if we found the thread
	beq $t0, $s0, waitthreadfound

	# Try the next thread
	lw $t0, 0x70($t0)
	j waitthreadloop

waitthreadfound:
	# The requested thread is running, so let's wait for it to die
	sw $s0, 0x78($k1)

	# Release the dispatcher lock
	addi $a0, $k0, 0x38
	jal krnl_spinlock_release

	# Yield the remainder of our time until the dispatcher schedules us again
	jal krnl_yield_thread

	# The thread is dead
	j waitthreadret

waitthreadnotfound:
	# Release the dispatcher lock
	addi $a0, $k0, 0x38
	jal krnl_spinlock_release

	# Thread must have already died, so we can return now
	j waitthreadret

waitthreadret:
	# Pop the stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 0x8

	# Return
	jr $ra

# void krnl_terminate_thread()
krnl_terminate_thread:
	la $a0, graceful_term_msg
	jal krnl_debug

	lw $t1, 0x74($k1) # Load the PCR address
	lw $t0, 0x08($t1) # Load the PCR's thread list head
	addi $t3, $t0, 0x0 # Save this value for later
	bne $t0, $k1, killfindthread # If this is not at the front of the list, loop to find it

	# The first thread one the run queue needs to die
	lw $t2, 0x70($k1)
	sw $t2, 0x08($t1)
	j threadkilled

	killfindthread:
		# Set the last thread
		addi $t1, $t0, 0x0

		# Lookup the next thread
		lw $t0, 0x70($t0)

		# Check if it's the thread we want
		bne $t0, $k1, killfindthread

	# Load this thread's next pointer
	lw $t2, 0x70($k1)

	# Store that value to the previous thread's next pointer
	sw $t2, 0x70($t1)

threadkilled:
	# Check for threads that are waiting on this thread's death
	lw $t0, 0x74($k1) # Get PCR again
	lw $t0, 0x08($t0) # Get the thread head from the PCR
	killthreadloop:
		# Check if the list has terminated
		beq $t0, $zero, killthreaddone

		# Check if we found the thread
		lw $t1, 0x78($t0)
		beq $t1, $k1, killedthread

		# Try the next thread
		lw $t0, 0x70($t0)
		j killthreadloop

	killedthread:
		# Remove this thread from the wait entry
		sw $zero, 0x78($t0)

		# Try the next thread
		lw $t0, 0x70($t0)
		j killthreadloop

killthreaddone:
	# Free this thread context
	addi $a0, $k1, 0x0
	jal krnl_free

	# Switch contexts to allow the dispatcher to select a new thread
	addi $k1, $t3, 0x0
	j krnl_schedule_new_thread

krnl_user_thread_exception:
	la $a0, term_msg
	jal krnl_io_write_string

	lw $t1, 0x74($k1) # Load the PCR address
	lw $t0, 0x08($t1) # Load the PCR's thread list head
	addi $t3, $t0, 0x0 # Save this value for later
	bne $t0, $k1, exceptionfindthread # If this is not at the front of the list, loop to find it

	# The first thread one the run queue needs to die
	lw $t2, 0x70($k1)
	sw $t2, 0x08($t1)
	j exceptionkilled

	exceptionfindthread:
		# Set the last thread
		addi $t1, $t0, 0x0

		# Lookup the next thread
		lw $t0, 0x70($t0)

		# Check if it's the thread we want
		bne $t0, $k1, exceptionfindthread

	# Load this thread's next pointer
	lw $t2, 0x70($k1)

	# Store that value to the previous thread's next pointer
	sw $t2, 0x70($t1)

exceptionkilled:
	# Check for threads that are waiting on this thread's death
	lw $t0, 0x74($k1) # Get PCR again
	lw $t0, 0x08($t0) # Get the thread head from the PCR
	exceptionthreadloop:
		# Check if the list has terminated
		beq $t0, $zero, exceptionthreaddone

		# Check if we found the thread
		lw $t1, 0x78($t0)
		beq $t1, $k1, exceptionremthread

		# Try the next thread
		lw $t0, 0x70($t0)
		j exceptionthreadloop

	exceptionremthread:
		# Remove this thread from the wait entry
		sw $zero, 0x78($t0)

		# Try the next thread
		lw $t0, 0x70($t0)
		j exceptionthreadloop

exceptionthreaddone:
	# Free this thread context
	addi $a0, $k1, 0x0
	jal krnl_free

	# Write the old status value back
	ori $k0, $k0, 0x2 # EXL bit is set
	mtc0 $k0, $12
	ehb

	# Restore k0
	lw $k0, KRNL_CONTEXT_ADDR

	# Switch contexts to allow the dispatcher to select a new thread
	addi $k1, $t3, 0x0
	j krnl_schedule_new_thread

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
	bne $t5, $zero, toidle

	# Grab the head of the list
	lw $t0, 0x8($t4)

	# Store that we've cycled before
	addi $t5, $zero, 0x1

	# If there are no other threads, idle
	beq $t0, $zero, toidle

testforblocked:
	# Check if the thread is blocked
	lw $t2, 0x78($t0)
	bne $t2, $zero, schedloop

	# Load the PCR
	lw $t4, 0x74($k1)

	# Check if this is a switch from the idle thread
	lw $t3, 0x0C($t4)
	beq $t3, $k1, fromidle

	# Switch to new thread
	addi $k1, $t0, 0x0

	# Resume it
	j krnl_unfreeze_thread

fromidle:
	# Switch to new thread
	addi $k1, $t0, 0x0

	# Exit low power mode
	jal hal_exit_low_power_mode

	# Resume it
	j krnl_unfreeze_thread

toidle:
	# Load the idle thread (PCR is in $t4)
	lw $k1, 0x0C($t4)

	# Set the platform to low power mode
	jal hal_enter_low_power_mode

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

	# Save HI and LO
	mfhi $t0
	mflo $t1
	sw $t0, 0x84($k1)
	sw $t1, 0x88($k1)

	# ----------- We are no longer in the context of that thread ----------

	j krnl_schedule_new_thread

krnl_yield_thread:
	# Disable interrupts
	mfc0 $k0, $12
	ori $k0, $k0, 0x2 # EXL
	mtc0 $k0, $12
	lw $k0, KRNL_CONTEXT_ADDR

	# Return address is the PC
	sw $ra, 0x80($k1)

	# Freeze the thread
	j krnl_freeze_thread

krnl_unfreeze_thread:
	# Disable interrupts and mask EXL and UM to allow EPC write
	di
	mfc0 $t0, $12
	li $t1, 0xFFFFFFED
	and $t1, $t0, $t1
	mtc0 $t1, $12
	ehb

	# Store the new PC
	lw $t2, 0x80($k1)
	mtc0 $t2, $14
	ehb

	# Restore interrupts and EXL
	mtc0 $t0, $12
	ei
	ehb

	# Restore HI and LO
	lw $t0, 0x84($k1)
	lw $t1, 0x88($k1)
	mthi $t0
	mtlo $t1

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

	# Restore k0
	lw $k0, KRNL_CONTEXT_ADDR

	# Return to the old PC
	eret
