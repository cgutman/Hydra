.globl krnl_open_file
.globl krnl_read_file
.globl krnl_write_file
.globl krnl_close_file

#
# File context
#
# 0x00 - File position
# 0x04 - File location on disk
#

# void* get_fd_context(int fd)
get_fd_context:
	# Look it up in the file table
	addi $t0, $k1, 0x11A0
	addi $t1, $k1, 0x11C0
	li $t2, 0x0
findentry:
	# Check if we've reached the end
	beq $t0, $t1, findfailed

	# Check if this is the one we want
	beq $a0, $t2, findentryfound

	# Nope, this one's full
	addi $t0, $t0, 0x08
	addi $t2, $t2, 0x01
	j findentry

findentryfound:
	# Check if this entry is empty
	lw $t2, 4($t0)
	beq $t2, $zero, findfailed

	# Otherwise this worked
	addi $v0, $t0, 0x0
	jr $ra

findfailed:
	# Failed to find this file
	li $v0, 0x0
	jr $ra

# int krnl_open_file(char* filename, int flags, int mode)
krnl_open_file:
	# Save the return address
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Call the filesystem to get the offset
	jal fs_open_file

	# Check if the open worked
	li $t0, -1
	beq $v0, $t0, openfailed

	# It did, so let's add an entry in the file table
	addi $t0, $k1, 0x11A0
	addi $t1, $k1, 0x11C0
	li $t3, 0
findemptyentry:
	# Check if we've reached the end
	beq $t0, $t1, openfailed

	# Check if this entry is empty
	lw $t2, 4($t0)
	beq $t2, $zero, foundentry

	# Nope, this one's full
	addi $t0, $t0, 0x08
	addi $t3, $t3, 0x01
	j findemptyentry

foundentry:
	# Write the file entry
	sw $zero, 0($t0)
	sw $v0, 4($t0)

	# Return the file descriptor
	addi $v0, $t3, 0x0
	j openret

openfailed:
	# Failure
	li $v0, -1
	j openret

openret:
	# Restore the return address and return
	lw $ra, 0($sp)
	addi $sp, $sp, 0x4
	jr $ra

# int krnl_close_file(int fd)
krnl_close_file:
	# Push the return address onto the stack
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Lookup the file context
	jal get_fd_context
	beq $v0, $zero, closefailed

	# Zero the file context
	sw $zero, 0($v0)
	sw $zero, 4($v0)

	# All good
	li $v0, 0
	j closeret

closefailed:
	# Failed
	li $v0, -1
	j closeret

closeret:
	# Pop the return address from the stack
	lw $ra, 0($sp)
	addi $sp, $sp, 0x4
	jr $ra

# int krnl_write_file(int fd, char* buf, int len)
krnl_write_file:
	# Push the return address onto the stack
	addi $sp, $sp, -0x8
	sw $ra, 0($sp)
	sw $s0, 4($sp)

	# Lookup the file context
	jal get_fd_context
	beq $v0, $zero, writefailed

	# Save the file context
	addi $s0, $v0, 0x0

	# Copy the arguments into the right position
	addi $a3, $a2, 0x0 # len
	addi $a2, $a1, 0x0 # buf
	lw $a1, 0($v0) # file pos
	lw $a0, 4($v0) # file offset on disk
	jal fs_write_file

	# Check if it failed
	li $t0, -1
	beq $t0, $v0, writefailed

	# Increment the position
	lw $t0, 0($s0)
	add $t0, $t0, $v0
	sw $t0, 0($s0)

	# Return
	j writeret

writefailed:
	# Write failed
	li $v0, -1
	j writeret

writeret:
	# Pop the return address from the stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 0x8
	jr $ra

# int krnl_read_file(int fd, char* buf, int len)
krnl_read_file:
	# Push the return address onto the stack
	addi $sp, $sp, -0x8
	sw $ra, 0($sp)
	sw $s0, 4($sp)

	# Lookup the file context
	jal get_fd_context
	beq $v0, $zero, readfailed

	# Save the file context
	addi $s0, $v0, 0x0

	# Copy the arguments into the right position
	addi $a3, $a2, 0x0 # len
	addi $a2, $a1, 0x0 # buf
	lw $a1, 0($v0) # file pos
	lw $a0, 4($v0) # file offset on disk
	jal fs_read_file

	# Check if it failed
	li $t0, -1
	beq $t0, $v0, readfailed

	# Increment the position
	lw $t0, 0($s0)
	add $t0, $t0, $v0
	sw $t0, 0($s0)

	# Return
	j readret

readfailed:
	# Read failed
	li $v0, -1
	j readret

readret:
	# Pop the return address from the stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 0x8
	jr $ra
