.data

#
# Loopback adapter implementation
#
# Context structure:
# 0x00 - Mutex
# 0x08 - Data ready event
# 0x10 - Buffer space available event
# 0x18 - Data pointer
# 0x1C - Buffer length
# 0x20 - Buffer

.text
# int krnl_loopback_recv(void* context, void* buf, int size)
krnl_loopback_recv:
	# Save return address and make room for saving arguments
	addi $sp, $sp, -0x10
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)

	# Save arguments
	addi $s0, $a0, 0x0
	addi $s1, $a1, 0x0
	addi $s2, $a2, 0x0

recvwait:
	# Wait for data
	addi $a0, $s0, 0x08 # Data ready event
	jal krnl_event_wait

	# Acquire mutex
	addi $a0, $s0, 0x0
	jal krnl_mutex_acquire

	# Check if data is available
	lw $t0, 0x18($s0)
	addi $t1, $s0, 0x20
	bne $t0, $t1, availablerecv

	# Nope, release the mutex and wait again
	addi $a0, $s0, 0x0
	jal krnl_mutex_release
	j recvwait

availablerecv:
	# Determine how much data will be returned
	subu $t2, $t0, $t1 # Compute data available
	slt $t3, $t2, $s2 # Less data available than requested?
	beq $t3, $zero, copyrecv # Nope, just copy

	# Otherwise, update size based on available data
	addi $s2, $t2, 0x0

copyrecv:
	# Copy the data into the caller's buffer
	addi $a0, $s1, 0x0
	addi $a1, $t1, 0x0
	addi $a2, $s2, 0x0
	jal krnl_memcpy

	# Update data pointer
	lw $t0, 0x18($s0)
	subu $t0, $t0, $s2 # Subtract data consumed
	sw $t0, 0x18($s0)

	# Signal the space available event (data may not have been consumed)
	addi $a0, $s0, 0x10 # Space available event
	jal krnl_event_signal

	# Release the mutex
	addi $a0, $s0, 0x0
	jal krnl_mutex_release

	# Return bytes copied
	addi $v0, $s2, 0x0

	# Pop saved data off stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 0x10

	jr $ra

# void krnl_loopback_recv(void* context, void* buf, int size)
krnl_loopback_send:
	# Save return address and make room for saving arguments
	addi $sp, $sp, -0x10
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)

	# Save arguments
	addi $s0, $a0, 0x0
	addi $s1, $a1, 0x0
	addi $s2, $a2, 0x0

sendwait:
	# Wait for space available
	addi $a0, $s0, 0x10 # Space available event
	jal krnl_event_wait

	# Acquire mutex
	addi $a0, $s0, 0x0
	jal krnl_mutex_acquire

	# Check if data is available
	lw $t0, 0x18($s0)
	lw $t1, 0x1C($s0)
	bne $t0, $t1, availablesend

	# Nope, release the mutex and wait again
	addi $a0, $s0, 0x0
	jal krnl_mutex_release
	j recvwait

availablesend:
	# Determine how much data will be returned
	subu $t2, $t0, $t1 # Compute data available
	slt $t3, $t2, $s2 # Less data available than requested?
	beq $t3, $zero, copyrecv # Nope, just copy

	# Otherwise, update size based on available data
	addi $s2, $t2, 0x0

copyrecv:
	# Copy the data into the caller's buffer
	addi $a0, $s1, 0x0
	addi $a1, $t1, 0x0
	addi $a2, $s2, 0x0
	jal krnl_memcpy

	# Update data pointer
	lw $t0, 0x18($s0)
	subu $t0, $t0, $s2 # Subtract data consumed
	sw $t0, 0x18($s0)

	# Signal the space available event (data may not have been consumed)
	addi $a0, $s0, 0x10 # Space available event
	jal krnl_event_signal

	# Release the mutex
	addi $a0, $s0, 0x0
	jal krnl_mutex_release

	# Return bytes copied
	addi $v0, $s2, 0x0

	# Pop saved data off stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 0x10

	jr $ra