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
	li $t0, 0x80000000 # Load the address to the next pointer
	lw $v0, 0($t0) # Load the next pointer to return

	add $t2, $v0, $a0 # Calculate the new next pointer

	li $t3, 0x80002000 # Load the upper bound address
	bgt $t2, $t3, allocfailed # Check if alloc exceeded that

	sw $t2, 0($t0) # Store the new next pointer
	jr $ra # Return the pointer to newly allocated memory

allocfailed:
	lw $v0, 0x0 # Load 0 into return register
	jr $ra # Return

# void krnl_mmregion_init()
krnl_mmregion_init:
	li $t0, 0x80000000 # Load the address of the next ptr
	addi $t1, $t0, 0x4 # Load the initial value of the next ptr
	sw $t1, 0($t0) # Store the initial value
	jr $ra # Return
