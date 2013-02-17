.globl krnl_spinlock_acquire
.globl krnl_spinlock_release
.globl krnl_spinlock_init

.data

.text

#
# Spinlocks are implemented as a 32-bit value that will hold either 0 or 1.
# 1 means the lock is acquired, 0 means the lock is released
#
# Cameron Gutman
#

# void krnl_spinlock_acquire(int* spinlock)
krnl_spinlock_acquire:
	ll $t0, 0($a0) # Load the current value of the spinlock
	bne $t0, $zero, krnl_spinlock_acquire # Try again if the lock is held

	li $t0, 0x1 # Generate the final spinlock value
	sc $t0, 0($a0) # Write the final value back
	beq $t0, $zero, krnl_spinlock_acquire # Try again if the atomic write failed 

	jr $ra # Return holding the lock

# void krnl_spinlock_release(int* spinlock)
krnl_spinlock_release:
	sync # Memory barrier to commit accesses before leaving the spinlock
	sw $zero, 0($a0) # Release the spinlock by writing 0 to it
	jr $ra # Return after releasing the lock

# void krnl_spinlock_init(int* spinlock)
krnl_spinlock_init:
	sw $zero, 0($a0) # Initialize the lock to 0 (unacquired)
	jr $ra # Return
		
