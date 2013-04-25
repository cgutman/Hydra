.globl krnl_io_switch_tty
.globl krnl_io_write_int
.globl krnl_io_write_float
.globl krnl_io_write_double
.globl krnl_io_write_string
.globl krnl_io_write_char
.globl krnl_io_read_int
.globl krnl_io_read_float
.globl krnl_io_read_double
.globl krnl_io_read_string
.globl krnl_io_read_char

.text
# void krnl_io_switch_tty(int)
krnl_io_switch_tty:
	# Switch the TTY in the thread struct
	sw $a0, 0x198($k1)
	jr $ra

# krnl_io_write_int(int)
krnl_io_write_int:
	# Save the return address first
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Allocate temporary buffer space for string
	addi $sp, $sp, -0x20 # 32 characters (NUL included)

	# Decode the integer into our string buffer
	# $a0 is already loaded
	addi $a1, $sp, 0x0 # Use stack space as a temp
	jal numlib_int_to_string

	# Now call the krnl function to write this string out
	addi $a0, $sp, 0x0
	jal krnl_io_write_string

	# Restore the stack
	addi $sp, $sp, 0x20
	lw $ra, 0($sp)
	addi $sp, $sp, 0x4
	jr $ra

# krnl_io_write_float(float)
krnl_io_write_float:
	jr $ra

# krnl_io_write_double(double)
krnl_io_write_double:
	jr $ra

# krnl_io_write_string(char*)
krnl_io_write_string:
	addi $a1, $a0, 0x0
	lw $a0, 0x198($k1)
	j krnl_serial_write_string

# krnl_io_write_char(char)
krnl_io_write_char:
	addi $a1, $a0, 0x0
	lw $a0, 0x198($k1)
	j krnl_serial_write_char

# int krnl_io_read_int()
krnl_io_read_int:
	# Save the return address first
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Allocate temporary buffer space for string
	addi $sp, $sp, -0x20 # 32 characters (NUL included)

	# Read the string in
	lw $a0, 0x198($k1)
	addi $a1, $sp, 0x0
	li $a2, 0x20
	jal krnl_serial_read_string

	# Decode the resulting string
	addi $a0, $sp, 0x0
	jal numlib_string_to_int

	# Restore the stack
	addi $sp, $sp, 0x20
	lw $ra, 0($sp)
	addi $sp, $sp, 0x04
	jr $ra

# float krnl_io_read_float()
krnl_io_read_float:
	jr $ra

# double krnl_io_read_double()
krnl_io_read_double:
	jr $ra

# char* krnl_io_read_string()
krnl_io_read_string:
	addi $a2, $a1, 0x0
	addi $a1, $a0, 0x0
	lw $a0, 0x198($k1)
	j krnl_serial_read_string

# char krnl_io_read_char()
krnl_io_read_char:
	lw $a0, 0x198($k1)
	j krnl_serial_read_char
