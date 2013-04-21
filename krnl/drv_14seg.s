.globl drv_write_char_led

.text
# void hal_write_char_led(uint16)
drv_write_char_led:
	# Push the return address onto the stack
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	li $a0, 0xC8
	jal hal_spi_write

	li $a0, 0x24
	jal hal_spi_write

	li $a0, 0x90
	jal hal_spi_write

	li $a0, 0x14
	jal hal_spi_write

	li $a0, 0xFF
	jal hal_spi_write

	lw $ra, 0($sp)
	addi $sp, $sp, 0x4

	jr $ra
