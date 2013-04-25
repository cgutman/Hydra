.globl drv_write_char_led
.globl drv_write_hello_led

.text
alphamap:
A: .word 0b0111011110000000
_B: .word 0b0111100010100100
C: .word 0b0100111000000000
D: .word 0b0111100000100100
E: .word 0b0100111110000000
F: .word 0b0100011110000000
G: .word 0b0101111010000000
H: .word 0b0011011110000000
I: .word 0b0100100000100100
_J: .word 0b0011110000000000
K: .word 0b0000011100011000
L: .word 0b0000111000000000
M: .word 0b0011011001010000
N: .word 0b0011011001001000
O: .word 0b0111111000000000
P: .word 0b0110011110000000
Q: .word 0b0111111000001000
R: .word 0b0110011110001000
S: .word 0b0101101110000000
T: .word 0b0100000000100100
U: .word 0b0011111000000000
V: .word 0b0000011000010010
W: .word 0b0011111000000100
X: .word 0b0000000001011010
Y: .word 0b0000000001010100
Z: .word 0b0100100000010010

nummap:
_0: .word 0b0111111000010010
_1: .word 0b0011000000000000
_2: .word 0b0110110110000000
_3: .word 0b0111100110000000
_4: .word 0b0011001110000000
_5: .word 0b0101101110000000
_6: .word 0b0101111110000000
_7: .word 0b0100000000010010
_8: .word 0b0111111110000000
_9: .word 0b0111101110000000

# int* char_to_addr(char)
char_to_addr:
	# Check for characters below the numbers
	li $t0, 0x30 # Zero character
	blt $a0, $t0, badchar

	# Check if it's above the numbers
	li $t0, 0x39 # Nine character
	ble $a0, $t0, numeric

	# Check if it's below the capital alphabet (but above the numbers)
	li $t0, 0x41 # Capital A
	blt $a0, $t0, badchar

	# Check if it's above the capital alphabet
	li $t0, 0x5A # Capital Z
	ble $a0, $t0, capital

	# Check if it's below the lowercase alphabet (but above the capital alphabet)
	li $t0, 0x61 # Lowercase A
	blt $a0, $t0, badchar

	# Check if it's above the lowercase alphabet
	li $t0, 0x7A # Lowercase Z
	ble $a0, $t0, lowercase

	# Otherwise it's a bad character
badchar:
	li $v0, 0x0
	jr $ra


capital:
	la $t0, alphamap
	addi $t1, $a0, -0x41 # Subtract capital A's value
	j goodret

lowercase:
	la $t0, alphamap
	addi $t1, $a0, -0x61 # Subtract lowercase A's value
	j goodret

numeric:
	la $t0, nummap
	addi $t1, $a0, -0x30 # Subtract the zero character's value
	j goodret

goodret:
	sll $t1, $t1, 2
	add $v0, $t0, $t1
	jr $ra

# void drv_write_char_led(uint16)
drv_write_char_led:
	# Push the return address and s0 onto the stack
	addi $sp, $sp, -0x14
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)

	# Save the input
	addi $s1, $a0, 0x0

	# Convert the first character to its segment form
	andi $a0, $s1, 0xFF
	jal char_to_addr
	beq $v0, $zero, failedwrite
	lw $v0, 0($v0)
	addi $s2, $v0, 0x0

	# Convert the second character to its segment form
	srl $a0, $s1, 8
	andi $a0, $a0, 0xFF
	jal char_to_addr
	beq $v0, $zero, failedwrite
	lw $v0, 0($v0)
	addi $s3, $v0, 0x0

	# Disable interrupts
	jal krnl_disable_interrupts
	addi $s0, $v0, 0x0

	# Select the 14-seg LED
	li $a0, 2
	jal hal_spi_select

	# Write the first octet from the second character
	srl $a0, $s3, 8
	ori $a0, $a0, 0x80
	jal hal_spi_trans

	# Write the second octet from the second character
	andi $a0, $s3, 0xFF
	srl $t0, $s2, 14
	or $a0, $a0, $t0
	jal hal_spi_trans

	# Write the remainder of the first octet from the first character
	srl $a0, $s2, 6
	andi $a0, $a0, 0xFF
	jal hal_spi_trans

	# Write the remainder of the second octet from the first character
	sll $a0, $s2, 2
	andi $a0, $a0, 0xFF
	jal hal_spi_trans

	li $a0, 0x00
	jal hal_spi_trans

	# Deselect the device
	jal hal_spi_deselect

	# Reenable interrupts
	addi $a0, $s0, 0x0
	jal krnl_restore_interrupts

failedwrite:
	# Restore the return address
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	lw $s2, 12($sp)
	lw $s3, 16($sp)
	addi $sp, $sp, 0x14

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
	jal hal_spi_trans

	#li $a0, 0x01
	li $a0, 0b00100100
	jal hal_spi_trans

	li $a0, 0b11011110
	jal hal_spi_trans

	li $a0, 0x00
	jal hal_spi_trans

	#li $a0, 0x10
	li $a0, 0x00
	jal hal_spi_trans

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
