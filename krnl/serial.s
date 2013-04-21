.globl krnl_serial_write_string
.globl krnl_serial_write_char
.globl krnl_serial_read_string
.globl krnl_serial_read_char


.text
# krnl_serial_read_char(port)
krnl_serial_read_char:
	j hal_uart_read

# krnl_serial_read_string(port)
krnl_serial_read_string:
	jr $ra

# krnl_serial_write_char(port, char)
krnl_serial_write_char:
	j hal_uart_write

# krnl_serial_write_string(port, char*)
krnl_serial_write_string:

	# Save s0, s1, and ra
	addi $sp, $sp, -0x0C
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $ra, 8($sp)

	# Store the input in s0 and s1
	addi $s0, $a0, 0x0
	addi $s1, $a1, 0x0

writeloop:
	# Load a character
	lb $a1, 0($s1)

	# If this is the terminator, break
	beq $a1, $zero, writedone

	# Write this character out
	addi $a0, $s0, 0x0
	jal hal_uart_write

	# Next character
	addi $s1, $s1, 0x01
	j writeloop

writedone:
	# Pop the stack and return
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 0x0C
	jr $ra
