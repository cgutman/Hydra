.globl drv_write_char_led

.text
# void hal_write_char_led(uint16)
drv_write_char_led:
	# Push the return address and s0 onto the stack
	addi $sp, $sp, -0x8
	sw $ra, 0($sp)
	sw $s0, 4($sp)

	# Disable interrupts
	jal krnl_disable_interrupts
	addi $s0, $v0, 0x0

	# Select the 14-seg LED
	li $a0, 2
	jal hal_spi_select

	# Output the characters
	#li $a0, 0x80
	#li $a0, 0b00100011
	li $a0, 0b11001000
	jal hal_spi_write

	#li $a0, 0x01
	li $a0, 0b00100100
	jal hal_spi_write

	li $a0, 0b11011110
	jal hal_spi_write

	li $a0, 0x00
	jal hal_spi_write

	#li $a0, 0x10
	li $a0, 0x00
	jal hal_spi_write

	# Deselect the device
	jal hal_spi_deselect

	# Reenable interrupts
	addi $a0, $s0, 0x0
	jal krnl_restore_interrupts

	# Restore the return address
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 0x8

	jr $ra
