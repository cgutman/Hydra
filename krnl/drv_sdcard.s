.globl sdcard_read
.globl sdcard_write
.globl sdcard_init

.data
sdresponse: .byte 0:6 # 6-byte response

.text
# sdcard_write_command(char command, int args, char crc, int responselength)
sdcard_write_command:
	# Push the saved regs and return address
	addi $sp, $sp, -0x14
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	# Save the arguments
	addi $s0, $a0, 0x0
	addi $s1, $a1, 0x0
	addi $s2, $a2, 0x0
	addi $s3, $a3, 0x0

	# Set the preamble bit
	ori $s0, $s0, 0x40

	# Pulse the SPI bus once
	li $a0, 1
	jal hal_spi_pulse

	# Write the command
	addi $a0, $s0, 0x0
	jal hal_spi_trans

	# Write the args
	srl $a0, $s1, 24
	andi $a0, $a0, 0xFF
	jal hal_spi_trans
	srl $a0, $s1, 16
	andi $a0, $a0, 0xFF
	jal hal_spi_trans
	srl $a0, $s1, 8
	andi $a0, $a0, 0xFF
	jal hal_spi_trans
	andi $a0, $s1, 0xFF
	jal hal_spi_trans

	# Set the trailing bit
	ori $s2, $s2, 0x01

	# Write the CRC and terminator
	addi $a0, $s2, 0x0
	jal hal_spi_trans

	# Read until we get a byte with the first bit clear
	la $s0, sdresponse
	la $s1, 0x00
	sdcardresponse:
		# Read a byte
		li $a0, 0xFF
		jal hal_spi_trans

		# If the byte started with a clear bit, it's valid
		andi $t0, $v0, 0x80
		bne $t0, $zero, sdcardresponse

		# Write to the buffer
		sb $v0, 0($s0)
		addi $s0, $s0, 0x1
		addi $s1, $s1, 0x1

		# Read more if requested
		bne $s1, $s3, sdcardresponse

	# Pulse the SPI bus once
	li $a0, 1
	jal hal_spi_pulse

	# Pop the saved variables and return address
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 0x14

	# Return
	jr $ra
	
# Wait for the idle bit to be set
sdcard_wait_for_idle:
	# Write the RA to stack
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

idlewaitloop:
	# Write CMD55 (to indicate an app-specific command is coming)
	li $a0, 55 # CMD55
	li $a1, 0 # No args
	li $a2, 0 # No CRC required
	li $a3, 0x01 # Response is 1 byte
	jal sdcard_write_command

	# Write ACMD41 (to initialize card)
	li $a0, 41 # ACMD41
	li $a1, 0 # No args
	li $a2, 0 # No CRC
	li $a3, 0x1 # Response is 1 byte
	jal sdcard_write_command

	# Check if the response has the idle bit clear
	la $t0, sdresponse
	lb $t0, 0($t0)
	andi $t0, $t0, 0x01
	beq $t0, $zero, idledone

	# Try again
	j idlewaitloop

idledone:
	# Pop the RA
	lw $ra, 0($sp)
	addi $sp, $sp, 0x4

	# Finished
	jr $ra

# void sdcard_init()
sdcard_init:
	# Write the RA to stack
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Disable interrupts (only safe because we're in init)
	di

	# Pulse the SPI bus 10 times
	li $a0, 10
	jal hal_spi_pulse

	# Select the SD card (pin 3)
	li $a0, 3
	jal hal_spi_select

	# Write CMD0 to enable SPI mode
	li $a0, 0 # CMD0
	li $a1, 0 # No args
	li $a2, 0x95 # CRC needed for this command
	li $a3, 0x01 # Response is 1 byte
	jal sdcard_write_command

	# Now wait for us to exit idle mode
	jal sdcard_wait_for_idle

	# Deselect the SD card
	jal hal_spi_deselect

	# Enable interrupts
	ei

	# Pop variables from stack
	lw $ra, 0($sp)
	addi $sp, $sp, 0x4

	# Done
	jr $ra
	
# bool sdcard_read(int offset, char buffer[512])
sdcard_read:
	# Write the RA to stack
	addi $sp, $sp, -0xC
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)

	# Save the buffer pointer
	addi $s0, $a1, 0x0
	addi $s1, $a0, 0x0

	# Disable interrupts (only safe because we're in init)
	di

	# Pulse the SPI bus 10 times
	li $a0, 10
	jal hal_spi_pulse

	# Select the SD card (pin 3)
	li $a0, 3
	jal hal_spi_select

	# Write CMD17
	li $a0, 17 # CMD17
	addi $a1, $s1, 0x0 # Offset
	li $a2, 0 # No CRC required
	li $a3, 0x01 # Response is 1 byte
	jal sdcard_write_command

	# Check if we received an error
	la $t0, sdresponse
	lbu $t0, 0($t0)
	bne $t0, $zero, sdreaderror

	# Wait for the data token
	sdreadwait:
		# Push 0xFF and read
		li $a0, 0xFF
		jal hal_spi_trans

		# Check if it's the magic value we want
		li $t0, 0xFE
		bne $v0, $t0, sdreadwait

	# Got the token, let's read the data
	li $s1, 0x0
	sdreaddata:
		# Check if we need to read more
		li $t0, 0x200
		beq $s1, $t0, readdatadone

		# Push 0xFF and read
		li $a0, 0xFF
		jal hal_spi_trans

		# Put this in the buffer
		sb $v0, 0($s0)
		addi $s0, $s0, 0x01

		# Next data
		addi $s1, $s1, 0x01
		j sdreaddata

readdatadone:
	# Read off the CRC16
	li $a0, 0xFF
	jal hal_spi_trans
	li $a0, 0xFF
	jal hal_spi_trans

	# Deselect the SD card
	jal hal_spi_deselect

	# Enable interrupts
	ei

	# Pop the stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 0xC

	# Return
	li $v0, 1
	jr $ra

sdreaderror:
	# Deselect the SD card
	jal hal_spi_deselect

	# Enable interrupts
	ei

	# Pop the stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 0xC

	# Return
	li $v0, 0
	jr $ra

# bool sdcard_write(char)
sdcard_write:
	# Unimplemented
	li $v0, 0x00
	jr $ra
