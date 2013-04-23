.globl sdcard_read
.globl sdcard_write
.globl sdcard_init

# int sdcard_write_command(char command, int args, char crc, int responselength)
sdcard_write_command:
	# Push the saved regs and return address
	addi $sp, $sp, -0x18
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)

	# Save the arguments
	addi $s0, $a0, 0x0
	addi $s1, $a1, 0x0
	addi $s2, $a2, 0x0
	addi $s3, $s3, 0x0

	# Set the preamble bit
	ori $s0, $s0, 0x40

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
	andi $a0, $s1, 0xFF
	jal hal_spi_trans
	andi $a0, $s1, 0xFF
	jal hal_spi_trans

	# Set the trailing bit
	ori $s2, $s2, 0x01

	# Write the CRC and terminator
	addi $a0, $s2, 0x0
	jal hal_spi_trans

	# Read a byte
	jal hal_spi_trans

	# Pop the saved variables and return address
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	lw $s4, 20($sp)
	addi $sp, $sp, 0x18

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
	andi $v0, $v0, 0x80
	beq $v0, $zero, idledone

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
	# Write the RA and S0 to stack
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Wait for at least 74 SPI cycles
	li $a0, 0x2EE0 # 12000 cycles
	jal krnl_wait_cycles

	# Disable interrupts (only safe because we're in init)
	di

	# Select the SD card (pin 3)
	li $a0, 3
	jal hal_spi_select

loop:

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
	
# char sdcard_read()
sdcard_read:
	jr $ra

# void sdcard_write(char)
sdcard_write:
	jr $ra
