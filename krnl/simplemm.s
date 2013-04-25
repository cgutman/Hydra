.globl krnl_mm_init
.globl krnl_paged_alloc
.globl krnl_npaged_alloc
.globl krnl_user_alloc
.globl krnl_free

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
	li $t0, 0x80002000 # Load the value of the first ptr
	sw $t0, 0x30($k0) # Store the first ptr

	# Write the initial pool header
	li $t1, 0x1E000
	sw $t1, 0($t0)
	sw $zero, 4($t0)

	li $t0, 0x80020000 # Load the upper bound
	sw $t0, 0x34($k0) # Store the upper bound

	li $v0, 0x0 # Return success

	addi $a0, $k0, 0x28 # Load the address of the Mm mutex
	j krnl_mutex_init # Initialize the Mm mutex and return

# void* krnl_paged_alloc(int size)
krnl_paged_alloc:
	j krnl_npaged_alloc # Forward to non-paged allocator

# void* krnl_npaged_alloc(int size)
krnl_npaged_alloc:
	# Push the return value on stack
	addi $sp, $sp, -0x8
	sw $ra, 0($sp)
	sw $s0, 4($sp)

	addi $s0, $a0, 0x0 # Store the size into a saved temp

	addi $a0, $k0, 0x28 # Load the address of the Mm mutex
	jal krnl_mutex_acquire # Get the mutex to protect the next pointer

	lw $t1, 0x30($k0) # Load the first pointer
	lw $t3, 0x34($k0) # Load the upper bound

nextalloc:
	# Load the size
	lw $t0, 0($t1)

	# Load the flags
	lw $t4, 4($t1)

	# Check if it's allocated
	bne $t4, $zero, nextblock

	# We can skip steps if the block is exactly the right size
	beq $t0, $s0, foundalloc

	# We'll have to split this entry if it's not
	bgt $t0, $s0, oversizealloc

nextblock:
	# Next block
	addi $t0, $t0, 0x8 # Advance past the header
	add $t1, $t1, $t0 # Advance to the next header

	# Check if this is above the upper bound
	bge $t1, $t3, allocfailed

	# Loop again
	j nextalloc

oversizealloc:
	# Calculate the address of the next header
	addi $t5, $s0, 0x8 # Advance past the header
	add $t5, $t1, $t5 # Add size to the current address

	# Write the new header
	sw $zero, 4($t5)
	subu $t4, $t0, $s0
	sw $t4, 0($t5)

foundalloc:
	sw $s0, 0($t1) # Store the size of the allocation
	li $t0, 0x01 # Allocated flag
	sw $t0, 4($t1) # Store the flags

	# Save the final return value
	addi $s0, $t1, 0x8 # Calculate the return value (allocation start + 8 bytes)

	addi $a0, $k0, 0x28 # Load the address of the Mm mutex
	jal krnl_mutex_release # Release the mutex

	addi $v0, $s0, 0x0 # Copy the return value back
	j finishalloc # Cleanup and return

allocfailed:
	addi $a0, $k0, 0x28 # Load the address of the Mm mutex
	jal krnl_mutex_release # Release the mutex

	li $v0, 0x0 # Return NULL

finishalloc:
	# Restore $s0
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 0x8

	jr $ra # Return the pointer to newly allocated memory

# void* krnl_user_alloc(int size)
krnl_user_alloc:
	j krnl_paged_alloc # Forward to paged allocator
	# TODO: We should zero allocated memory for security reasons

# void krnl_free(void* buffer)
krnl_free:
	addi $a0, $a0, -0x8
	sw $zero, 4($a0)
	jr $ra
	