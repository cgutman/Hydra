.globl drv_write_char_led
.globl drv_write_hello_led

.text
# void drv_write_char_led(char)
drv_write_char_led:
	# Push the return address and s0 onto the stack
	addi $sp, $sp, -0xC
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)

	# Save the char
	addi $s1, $a0, 0x0

	# Disable interrupts
	jal krnl_disable_interrupts
	addi $s0, $v0, 0x0

	# Select the 14-seg LED
	li $a0, 2
	jal hal_spi_select

	# Output the characters
	addi $a0, $s1, 0x0
	jal hal_spi_write

	addi $a0, $s1, 0x0
	jal hal_spi_write

	addi $a0, $s1, 0x0
	jal hal_spi_write

	addi $a0, $s1, 0x0
	jal hal_spi_write

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
	lw $s1, 8($sp)
	addi $sp, $sp, 0xC

	jr $ra

# void drv_write_hello_led()
drv_write_hello_led:
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
