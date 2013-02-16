.globl krnl_mutex_acquire
#.globl krnl_mutex_release
#.globl krnl_mutex_init

.data

.text
# void krnl_mutex_acquire(int* mutex)
krnl_mutex_acquire:

	# Save s0
	addi $sp, $sp, 0x4
	sw $s0, 0($sp)

	addi $s0, $a0, 0x0 # Save the mutex pointer

	# Push the return address onto the stack
	addi $sp, $sp, 0x4
	sw $ra, 0($sp)

	spinloop:
		jal krnl_disable_interrupts # Disable interrupts to prevent races (v0 gets interrupt state)

		lw $t0, 0($s0) # Load the current value of mutex
		beq $t0, $zero, finalizeacquire # Branch if we get the lock

		addi $a0, $v0, 0x0 # Load krnl_disable_interrupts return value as parameter 0
		jal krnl_restore_interrupts # Restore interrupts to allow us to be preempted while looping

		jal krnl_sleep_thread # Sleep the thread

		j spinloop # Try again

	finalizeacquire:
		li $t0, 0x1 # Generate the final spinlock value
		sw $t0, 0($s0) # Acquire the spinlock by writing 1 to it

		addi $a0, $v0, 0x0 # Load krnl_disable_interrupts return value as parameter 0
		jal krnl_restore_interrupts # Restore interrupts to allow preemption again

		# Pop the return address off the stack
		lw $ra, 0($sp)
		addi $sp, $sp, -0x4

		# Restore s0
		lw $s0, 0($sp)
		addi $sp, $sp, -0x4

		jr $ra # Return holding the lock

# void krnl_spinlock_release(int* spinlock)
krnl_spinlock_release:
	sw $zero, 0($a0) # Release the spinlock by writing 0 to it
	jr $ra # Return after releasing the lock

# void krnl_spinlock_init(int* spinlock)
krnl_spinlock_init:
	sw $zero, 0($a0) # Initialize the lock to 0 (unacquired)
	jr $ra # Return
	