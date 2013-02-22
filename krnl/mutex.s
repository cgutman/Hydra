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
	addi $sp, $sp, -0x8
	sw $s0, 0($sp)

	# Push the return address onto the stack
	sw $ra, 4($sp)

	addi $s0, $a0, 0x0 # Save the mutex pointer

	# Acquire the mutex contention lock for MP synchronization
	addi $a0, $k0, 0x38
	jal krnl_spinlock_acquire

loadcurrent:
	ll $t0, 0($s0) # Load the current value of mutex
	beq $t0, $zero, noncontendedacquire # Branch if we get the lock the first time

	# Nope didn't get it, so we have to setup some wait context

	# Store the mutex as the thread's wait object
	sw $s0, 0x78($k1)

	# Get the head of the waiter list
	lw $t2, 0x04($s0)

	# Check if anyone is waiting already
	beq $t2, $zero, firstwaiter

acquireloop:
	# Read this thread's next waiter entry
	addi $t0, $t2, 0x7C # Save the address for foundend
	lw $t2, 0($t0)

	# Check if we've reached the end of the linked list
	beq $t2, $zero, foundend

	# Continue traversing the linked list
	j acquireloop

firstwaiter:
	# We're the head of the list
	sw $k1, 4($s0)
	j waitforacquire

foundend:
	# We're at the end ($t0 contains the address of the empty entry)
	sw $k1, 0($t0)

waitforacquire:
	# Release the mutex contention lock
	addi $a0, $k0, 0x38
	jal krnl_spinlock_release

	jal krnl_yield_thread # Sleep the thread until the mutex is released

	# Cleanup and return
	j finalizeacquire

noncontendedacquire:
	addi $t0, $k1, 0x0 # Save thread context
	sc $t0, 0($s0)  # This thread context is the mutex's value
	beq $t0, $zero, loadcurrent # Try again if the save failed

	# Release the mutex contention lock
	addi $a0, $k0, 0x38
	jal krnl_spinlock_release

finalizeacquire:
	# Pop the return address off the stack
	lw $ra, 4($sp)

	# Restore s0
	lw $s0, 0($sp)
	addi $sp, $sp, 0x8

	jr $ra # Return holding the lock

# void krnl_mutex_release(int* mutex)
krnl_mutex_release:
	# Push the return address and s0 onto the stack
	addi $sp, $sp, -0x8
	sw $ra, 0($sp)
	sw $s0, 4($sp)

	# Save the mutex pointer
	addi $s0, $a0, 0x0

	# Acquire the mutex contention lock
	addi $a0, $k0, 0x38
	jal krnl_spinlock_acquire

	# Check if another thread wants this mutex
	lw $t1, 4($s0)
	bne $t1, $zero, mutexhandoff

	sw $zero, 0($s0) # Nobody waiting, so release the mutex by writing 0 to it

	# Release the mutex contention lock
	addi $a0, $k0, 0x38
	jal krnl_spinlock_release

finalizerelease:
	# Pop the saved state off the stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 0x8

	# Wait for memory write to propagate
	sync

	jr $ra # Return after releasing the lock

mutexhandoff:
	# Another thread wants this mutex ($t1 has thread pointer)

	# Clear the wait object in the next thread
	sw $zero, 0x78($t1)

	# Move the next thread in wait queue to the waiter list head
	lw $t3, 0x7C($t1) # Load it from the next thread
	sw $t3, 4($s0) # Store it to the mutex
	sw $zero, 0x7C($t1) # Clear it from the next thread

	# Release the mutex contention lock
	addi $a0, $k0, 0x38
	jal krnl_spinlock_release

	# Give the newly eligible thread a chance to run
	jal krnl_yield_thread

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
