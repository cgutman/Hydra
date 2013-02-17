.globl krnl_mmregion_alloc
.globl krnl_mmregion_init

#
# This memory allocator is for early boot allocation
# before the normal memory manager is available. It
# is used to allocate permanently resident state like
# the PCR and initial thread. This is NOT thread-safe
# so it should not be used after boot-time.
#

# void* krnl_mmregion_alloc(int size)
krnl_mmregion_alloc:
	lw $v0, 0x20($k0) # Load the next pointer to return
	add $t2, $v0, $a0 # Calculate the new next pointer

	lw $t3, 0x24($k0) # Load the upper bound address
	bgt $t2, $t3, allocfailed # Check if alloc exceeded that

	sw $t2, 0x20($k0) # Store the new next pointer
	jr $ra # Return the pointer to newly allocated memory

allocfailed:
	lw $v0, 0x0 # Load 0 into return register
	jr $ra # Return

# int krnl_mmregion_init()
krnl_mmregion_init:
	li $t0, 0x80000100 # Load the value of the next ptr
	sw $t0, 0x20($k0) # Store the next ptr

	li $t0, 0x80001000 # Load the value of the upper bound
	sw $t0, 0x24($k0) # Store the upper bound

	li $v0, 0x0 # Success

	jr $ra # Return
