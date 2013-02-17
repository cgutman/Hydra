.globl krnl_mm_init
.globl krnl_paged_alloc


.data



.text

#
# This file implements a VERY simple memory manager. All it does is use a pointer
# located at the start of the address space and increment it based on the size
# required. It prepends the size of the allocation to the allocated memory.
# It doesn't support free, so don't allocate much memory :P
#

# int krnl_mm_init(void)
krnl_mm_init:
	li $v0, 0x0 # Return success

	li $t0, 0x80002008 # Load the address of the next ptr
	addi $t1, $t0, 0x4 # Load the initial value of the next ptr
	sw $t1, 0($t0) # Store the initial value

	li $a0, 0x80002000 # Load the address of the Mm mutex
	j krnl_mutex_init # Initialize the Mm mutex and return

# void* krnl_paged_alloc(int size)
krnl_paged_alloc:
	j krnl_npaged_alloc # Forward to non-paged allocator

# void* krnl_npaged_alloc(int size)
krnl_npaged_alloc:
	# Push the return value on stack
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Save s0
	addi $sp, $sp, -0x4
	sw $s0, 0($sp)

	addi $s0, $a0, 0x0 # Store the size into a saved temp

	li $a0, 0x80002000 # Load the address of the Mm mutex
	jal krnl_mutex_acquire # Get the mutex to protect the next pointer

	li $t0, 0x80002008 # Load the address to the next pointer
	lw $t1, 0($t0) # Load the next pointer

	add $t2, $t1, $s0 # Calculate the new next pointer
	addi $t4, $t2, 0x4 # Save space for the size to prepend to the allocation

	li $t3, 0x80008000 # Load the upper bound for allocations
	bge $t4, $t3, allocfailed # Check that the allocation is within this range

	sw $s0, 0($t2) # Store the size of the allocation
	sw $t4, 0($t0) # Store the new next pointer

	# Save the final return value
	addi $s0, $t1, 0x4 # Calculate the return value (allocation start + 4 bytes)

	li $a0, 0x80002000 # Load the address of the Mm mutex
	jal krnl_mutex_release # Release the mutex

	addi $v0, $s0, 0x0 # Copy the return value back
	j finishalloc # Cleanup and return

allocfailed:
	li $a0, 0x80002000 # Load the address of the Mm mutex
	jal krnl_mutex_release # Release the mutex

	li $v0, 0x0 # Return NULL

finishalloc:
	# Restore $s0
	lw $s0, 0($sp)
	addi $sp, $sp, 0x4

	# Pop $ra off stack
	lw $ra, 0($sp)
	addi $sp, $sp, 0x4

	jr $ra # Return the pointer to newly allocated memory


# void* krnl_user_alloc(int size)
krnl_user_alloc:
	j krnl_paged_alloc # Forward to paged allocator
	# TODO: We should zero allocated memory for security reasons
