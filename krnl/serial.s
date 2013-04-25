.globl krnl_serial_write_string
.globl krnl_serial_write_char
.globl krnl_serial_read_string
.globl krnl_serial_read_char

.text
# krnl_serial_read_char(port)
krnl_serial_read_char:
	j hal_uart_read

# krnl_serial_read_string(port, char*, len)
krnl_serial_read_string:
	# Save s0-s2 and ra
	addi $sp, $sp, -0x10
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)

	# Save arguments
	addi $s0, $a0, 0x0
	addi $s1, $a1, 0x0
	addi $s2, $a2, -0x1 # Leave 1 space open for the NUL

readloop:
	# Check if we're out of buffer space
	beq $s2, $zero, readdone

	# Read in a new character
	addi $a0, $s0, 0x0
	jal krnl_serial_read_char

	# Check if it's a null
	beq $v0, $zero, readdone

	# Write this character out
	addi $a0, $s0, 0x0
	addi $a1, $v0, 0x0
	jal hal_uart_write

	# Check if it's a CR
	li $t0, 0xD
	beq $v0, $t0, crprint

	# Write the character to the buffer
	sb $v0, 0($s1)

	# Increment buffer pointer and decrement buffer len
	addi $s1, $s1, 0x01
	addi $s2, $s2, -0x01
	j readloop

crprint:
	# Write a line feed
	addi $a0, $s0, 0x0
	li $a1, 0xA # LF
	jal hal_uart_write

readdone:
	# Add a NUL terminator
	sb $zero, 0($s1)

	# Restore stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 0x10
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

	# Check if it's a LF
	li $t0, 0xA
	beq $a1, $t0, lfprint

	# Loop again
	j writeloop

lfprint:
	# Write a carriage return
	addi $a0, $s0, 0x0
	li $a1, 0xD # CR
	jal hal_uart_write

	# Loop again
	j writeloop

writedone:
	# Pop the stack and return
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 0x0C
	jr $ra
