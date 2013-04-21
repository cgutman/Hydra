.globl krnl_debug

# krnl_debug(char*)
krnl_debug:
	addi $a1, $a0, 0x0
	li $a0, 2
	j krnl_serial_write_string
