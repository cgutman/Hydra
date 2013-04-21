.globl drv_write_char_led

.text
# void hal_write_char_led(uint16)
drv_write_char_led:
	# Push the return address onto the stack
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Select the 14-seg LED
	li $a0, 2
	jal hal_spi_select

	# Output the characters
	#li $a0, 0xC8
	li $a0, 0x13
	jal hal_spi_write

	li $a0, 0x24
	jal hal_spi_write

	li $a0, 0xFF
	jal hal_spi_write

	li $a0, 0xFF
	jal hal_spi_write

	li $a0, 0xF0
	jal hal_spi_write

	# Deselect the device
	jal hal_spi_deselect

	# Restore the return address
	lw $ra, 0($sp)
	addi $sp, $sp, 0x4

	jr $ra
