.globl numlib_char_to_int
.globl numlib_digit_to_char
.globl numlib_string_to_int

.text
# char numlib_digit_to_char(int)
numlib_digit_to_char:
	addi $v0, $a0, 0x30 # 30h is ASCII zero character
	jr $ra

# int numlib_char_to_int(char)
numlib_char_to_int:
	addi $v0, $a0, -0x30 # 30h is ASCII zero character
	jr $ra

# int numlib_string_to_int(char*)
numlib_string_to_int:
	# Push state onto the stack
	addi $sp, $sp, -0x0C
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)

	addi $s0, $a0, 0x0
	li $s1, 0x0
stringreadloop:
	# Load a character
	lb $a0, 0($s0)

	# Check if it's a NUL
	beq $a0, $zero, stringreaddone

	# Convert this char to an int
	jal numlib_char_to_int

	# Shift our number left by one place
	li $t0, 10
	mul $s1, $s1, $t0

	# Add this character's value
	add $s1, $s1, $v0

	# Next character
	addi $s0, $s0, 1
	j stringreadloop

stringreaddone:
	# Write the return value
	addi $v0, $s1, 0x0

	# Pop saved stack from the stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 0x0C

	jr $ra
