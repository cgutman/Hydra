.globl fs_read_file
.globl fs_write_file
.globl fs_open_file

.data
fs_mounted_msg: .asciiz "JankyFS volume mounted\r\n"

sector_buffer: .byte 0:512

.text
# int fs_open_file(char* file)
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

	# Get the current file name
	la $a0, sector_buffer
	add $a0, $a0, $s2 # Add the current entry offset
	addi $a0, $a0, 0x4 # Offset to the file name

	# Compare the file name to the one requested
	addi $a1, $s0, 0x0
	li $a2, 0x10
	jal memcmp

	# If it's the same, we're done
	beq $v0, $zero, opengood

	# Move to the next entry
	addi $s1, $s1, -1
	addi $s2, $s2, 0x04
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
	# Load the position of this file on disk and return it
	la $v0, sector_buffer
	add $v0, $v0, $s2
	addi $v0, $v0, 0x18
	lw $v0, 0($v0)
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
	addi $sp, $sp, -0x14
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	# Save the buffer and len
	addi $s0, $a2, 0x0
	addi $s1, $a3, 0x0

	# Get the read location
	jal get_loc_tuple_from_offset_pos

	# Save location
	addi $s2, $v0, 0x0
	addi $s3, $v1, 0x0

readloop:
	# Read a sector
	addi $a0, $s2, 0x0
	la $a1, sector_buffer
	jal sdcard_read

	# Check that the read was successful
	beq $v0, $zero, readfailed

	# Determine how much data we can copy
	li $t1, 0x200
	sub $t0, $t1, $s3
	ble $t0, $s1, readcopy

	# We don't have enough room for it all
	addi $t0, $s1, 0x0

readcopy:
	# Copy data from the offset into the buffer
	add $


readfailed:
	li $v0, -1
	j readret

readret:
	# Push state onto stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 0x14

	# Return
	jr $ra

# int fs_write_file(int diskoffset, int pos, char* buf, int len)
fs_write_file:
	# Unimplemented
	li $v0, -1
	jr $ra
