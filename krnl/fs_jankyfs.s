.globl fs_read_file
.globl fs_write_file
.globl fs_open_file

.data
sector_buffer: .byte 0:512

.text
# int,int fs_open_file(char* file)
fs_open_file:
	# Push state onto stack
	addi $sp, $sp, -0x14
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	# Save the filename
	addi $s0, $a0, 0x0

	# Read the first sector of the index
	li $a0, 0x0
	la $a1, sector_buffer
	jal sdcard_read

	# Check that the read was successful
	beq $v0, $zero, openfailed

	# Load the signature
	la $t0, sector_buffer
	lw $t0, 0($t0)

	# Check for the correct signature
	li $t1, 0xFFFFFFFF
	li $v0, 0x0
	bne $t1, $t0, openfailed

	# Load the number of entries
	la $t0, sector_buffer
	lw $s1, 8($t0)
	
	# Start enumerating files
	li $s3, 0x200 # Next sector is at 512 bytes
	li $s2, 0x20 # Start at 32 bytes (after the header)
sectorloop:
	# Check if we have more to read
	beq $s1, $zero, openfailed

	# Check if we've read 512 bytes
	li $t0, 0x200
	beq $t0, $s2, sectordone

	# Only compare the number of bytes in the file name
	addi $a0, $s0, 0x0
	jal strlen
	addi $a2, $v0, 0x1 # Also check the NUL

	# Get the current file name
	la $a0, sector_buffer
	add $a0, $a0, $s2 # Add the current entry offset
	addi $a0, $a0, 0x4 # Offset to the file name

	# Compare the file name to the one requested
	addi $a1, $s0, 0x0
	jal memcmp

	# If it's the same, we're done
	beq $v0, $zero, opengood

	# Move to the next entry
	addi $s1, $s1, -1
	addi $s2, $s2, 0x20
	j sectorloop

sectordone:
	# We need to read another sector
	addi $a0, $s3, 0x0
	la $a1, sector_buffer
	jal sdcard_read

	# Check that the read was successful
	beq $v0, $zero, openfailed

	# Reset our offset
	li $s2, 0x0

	# Increment our next sector offset
	addi $s3, $s3, 0x200

	# Start again
	j sectorloop

opengood:
	# Load the position of this file on disk
	la $v0, sector_buffer
	add $v0, $v0, $s2
	addi $v0, $v0, 0x14
	lw $v0, 0($v0)

	# Load 
	j openret

openfailed:
	# We failed
	li $v0, -1
	j openret

openret:
	# Pop state from stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 0x14

	jr $ra

# int,int get_loc_tuple_from_offset_pos(int offset, int pos)
get_loc_tuple_from_offset_pos:
	# Divide the position by the sector size
	li $v0, 0x200
	div $a1, $v0

	# Load the number of sectors that we should read
	mflo $v0

	# Load the offset within the sector of our data
	mfhi $v1

	# Compute the address to start reading
	sll $v0, $v0, 9
	add $v0, $v0, $a0

	# Done
	jr $ra

# int fs_read_file(int diskoffset, int pos, char* buf, int len)
fs_read_file:
	# Push state onto stack
	addi $sp, $sp, -0x20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)

	# Save the buffer and len
	addi $s0, $a2, 0x0
	addi $s1, $a3, 0x0

	# Temporarily save the offset and position
	addi $s2, $a0, 0x0
	addi $s3, $a1, 0x0

	# Get the read location from the start
	li $a1, 0x0
	jal get_loc_tuple_from_offset_pos

	# Read a sector
	addi $a0, $v0, 0x0
	la $a1, sector_buffer
	jal sdcard_read

	# Check that the read was successful
	beq $v0, $zero, readfailed

	# Read the size
	la $t0, sector_buffer
	lw $s6, 0x4($t0)

	# Restore the offset and position
	addi $a0, $s2, 0x0
	addi $a1, $s3, 0x0

	# Subtract the current position from the size
	sub $s6, $s6, $a1

	# Offset the read by the header size
	addi $a1, $a1, 0x20

	# Get the read location
	jal get_loc_tuple_from_offset_pos

	# Save location
	addi $s2, $v0, 0x0
	addi $s3, $v1, 0x0

	# Track the number of bytes read
	li $s4, 0x0
readloop:
	# Check if there's more buffer space
	beq $s1, $zero, readdone

	# Check if there's more data in the file
	beq $s6, $zero, readdone

	# Read a sector
	addi $a0, $s2, 0x0
	la $a1, sector_buffer
	jal sdcard_read

	# Check that the read was successful
	beq $v0, $zero, readfailed

	# Determine how much data we can copy
	li $t1, 0x200
	sub $s5, $t1, $s3
	ble $s5, $s1, readcheck

	# We don't have enough room for it all
	addi $s5, $s1, 0x0

readcheck:
	# Only read as much as we have left
	ble $s5, $s6, readcopy

	# Limited by file size
	addi $s5, $s6, 0x0

readcopy:
	# Copy data from the offset into the buffer
	addi $a0, $s0, 0x0
	la $a1, sector_buffer
	add $a1, $a1, $s3
	addi $a2, $s5, 0x0
	jal memcpy

	# Update read state
	add $s0, $s0, $s5 # Increment buf
	sub $s1, $s1, $s5 # Decrement len
	sub $s6, $s6, $s5 # Decrement file size
	addi $s2, $s2, 0x200 # Next sector
	li $s3, 0x0 # No more sector offset
	add $s4, $s4, $s5 # Increment bytes read

	# Next read
	j readloop

readdone:
	# Copy the bytes read into the return var
	addi $v0, $s4, 0x0
	j readret

readfailed:
	# Read failed
	li $v0, -1
	j readret

readret:
	# Push state onto stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	lw $s5, 24($sp)
	lw $s6, 28($sp)
	addi $sp, $sp, 0x20

	# Return
	jr $ra

# int fs_write_file(int diskoffset, int pos, char* buf, int len)
fs_write_file:
	# Unimplemented
	li $v0, -1
	jr $ra
