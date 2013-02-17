.globl krnl_spinlock_acquire
.globl krnl_spinlock_release
.globl krnl_spinlock_init

.data

.text

#
# Spinlocks are implemented as a 32-bit value that will hold either 0 or 1.
# 1 means the lock is acquired, 0 means the lock is released
#
# Interrupts are disabled in krnl_spinlock_acquire, but are restored by its return.
# This means that threads ARE preemptible while holding a spinlock.
#
# The implementation of krnl_spinlock_acquire thrashes the interrupt controller state,
# but at this point I'm not terribly concerned.
#
# Cameron Gutman
#

# void krnl_spinlock_acquire(int* spinlock)
krnl_spinlock_acquire:

	# Save s0
	addi $sp, $sp, -0x4
	sw $s0, 0($sp)

	addi $s0, $a0, 0x0 # Save the spinlock pointer

	# Push the return address onto the stack
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	spinloop:
		jal krnl_disable_interrupts # Disable interrupts to prevent races (v0 gets interrupt state)

		lw $t0, 0($s0) # Load the current value of spinlock
		beq $t0, $zero, finalizeacquire # Branch if we get the lock

		addi $a0, $v0, 0x0 # Load krnl_disable_interrupts return value as parameter 0
		jal krnl_restore_interrupts # Restore interrupts to allow us to be preempted while looping

		j spinloop # Try again

	finalizeacquire:
		li $t0, 0x1 # Generate the final spinlock value
		sw $t0, 0($s0) # Acquire the spinlock by writing 1 to it

		addi $a0, $v0, 0x0 # Load krnl_disable_interrupts return value as parameter 0
		jal krnl_restore_interrupts # Restore interrupts to allow preemption again

		# Pop the return address off the stack
		lw $ra, 0($sp)
		addi $sp, $sp, 0x4

		# Restore s0
		lw $s0, 0($sp)
		addi $sp, $sp, 0x4

		jr $ra # Return holding the lock

# void krnl_spinlock_release(int* spinlock)
krnl_spinlock_release:
	sw $zero, 0($a0) # Release the spinlock by writing 0 to it
	jr $ra # Return after releasing the lock

# void krnl_spinlock_init(int* spinlock)
krnl_spinlock_init:
	sw $zero, 0($a0) # Initialize the lock to 0 (unacquired)
	jr $ra # Return
		
