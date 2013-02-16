.globl krnl_mutex_acquire
.globl krnl_mutex_release
.globl krnl_mutex_init
.globl krnl_mutex_is_locked

.data

.text

# Mutex is 8 bytes
# 0x0 Locked
# 0x4 Head of waiting thread list

# void krnl_mutex_acquire(int* mutex)
krnl_mutex_acquire:

	# Save s0
	addi $sp, $sp, 0x4
	sw $s0, 0($sp)

	addi $s0, $a0, 0x0 # Save the mutex pointer

	# Push the return address onto the stack
	addi $sp, $sp, 0x4
	sw $ra, 0($sp)

	jal krnl_disable_interrupts # Disable interrupts to prevent races (v0 gets interrupt state)

	lw $t0, 0($s0) # Load the current value of mutex
	beq $t0, $zero, noncontendedacquire # Branch if we get the lock the first time

	# Nope didn't get it, so we have to setup some wait context

	# Store the mutex as the thread's wait object
	addi $t1, $gp, 0x78
	sw $s0, 0($t1)

	# Get the head of the waiter list
	lw $t2, 4($s0)

	# Check if anyone is waiting already
	beq $t2, $zero, firstwaiter

acquireloop:
	# Read this thread's next waiter entry
	addi $t0, $t2, 0x7C
	lw $t2, 0($t0)

	# Check if we've reached the end of the linked list
	beq $t2, $zero, foundend

	# Continue traversing the linked list
	j acquireloop

firstwaiter:
	# We're the head of the list
	sw $gp, 4($s0)
	j waitforacquire

foundend:
	# We're at the end ($t0 contains the address of the empty entry)
	sw $gp, 0($t0)

waitforacquire:
	addi $a0, $v0, 0x0 # Load krnl_disable_interrupts return value as parameter 0
	jal krnl_restore_interrupts # Restore interrupts before waiting

	jal krnl_sleep_thread # Sleep the thread until the mutex is released

	# Cleanup and return
	j finalizeacquire

noncontendedacquire:
	sw $gp, 0($s0)  # This thread context is the mutex's value

	addi $a0, $v0, 0x0 # Load krnl_disable_interrupts return value as parameter 0
	jal krnl_restore_interrupts # Restore interrupts to allow preemption again

finalizeacquire:
	# Pop the return address off the stack
	lw $ra, 0($sp)
	addi $sp, $sp, -0x4

	# Restore s0
	lw $s0, 0($sp)
	addi $sp, $sp, -0x4

	jr $ra # Return holding the lock

# void krnl_mutex_release(int* mutex)
krnl_mutex_release:
	# Push the return address onto the stack
	addi $sp, $sp, 0x4
	sw $ra, 0($sp)

	jal krnl_disable_interrupts # Disable interrupts to prevent races (v0 gets interrupt state)

	# Check if another thread wants this mutex
	lw $t1, 4($a0)
	bne $t1, $zero, mutexhandoff

	sw $zero, 0($a0) # Nobody waiting, so release the mutex by writing 0 to it

	addi $a0, $v0, 0x0 # Load krnl_disable_interrupts return value as parameter 0
	jal krnl_restore_interrupts # Restore interrupts to allow preemption again

finalizerelease:
	# Pop the return address off the stack
	lw $ra, 0($sp)
	addi $sp, $sp, -0x4

	jr $ra # Return after releasing the lock

mutexhandoff:
	# Another thread wants this mutex ($t1 has thread pointer)

	# Clear the wait object in the next thread
	addi $t2, $t1, 0x78
	sw $zero, 0($t2)

	# Move the next thread in wait queue to the waiter list head
	addi $t2, $t1, 0x7C
	lw $t3, 0($t2) # Load it from the next thread
	sw $t3, 4($a0) # Store it to the mutex
	sw $zero, 0($t2) # Clear it from the next thread

	addi $a0, $v0, 0x0 # Load krnl_disable_interrupts return value as parameter 0
	jal krnl_restore_interrupts # Restore interrupts to allow preemption again

	# Give the newly eligible thread a chance to run
	jal krnl_sleep_thread

	# Cleanup and return
	j finalizerelease

# void krnl_mutex_init(int* mutex)
krnl_mutex_init:
	sw $zero, 0($a0) # Initialize the lock to 0 (unacquired)
	sw $zero, 4($a0) # Initialize next waiter to 0
	jr $ra # Return

# int krnl_mutex_is_locked(int* mutex)
krnl_mutex_is_locked:
	lw $t1, 0($a0) # Load the current holding thread
	bne $t1, $zero, acquired # Check if somebody owns it

	notacquired:
		li $v0, 0x0 # Return 0x0 for not acquired
		jr $ra

	acquired:
		li $v0, 0x1 # Return 0x1 for acquired
		jr $ra
