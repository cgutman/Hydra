.globl main

.data


.text
main:
	# Initialize the LEDs
	jal init

	# Initialize the kernel
	la $a0, userstart
	jal krnl_init

userstart:

	# Initialize the mutex
	li $a0, 0x80004000
	li $v0, 22 # mutex init
	syscall

	# Start a new thread
	la $a0, test1
	li $a1, 0x80004000
	li $v0, 21 # create thread
	syscall

loop:
	j loop

test1:
	# Start a new thread
	la $a0, test2
	li $a1, 0x80004000
	li $v0, 21 # create thread
	syscall

	# Spawn a third thread
	la $a0, test3
	li $v0, 21 # Create thread
	syscall

	addi $s0, $a1, 0x0
	li $a1, 0x0

	t1:
		addi $a0, $s0, 0x0
		li $v0, 19 # Acquire mutex
		syscall

		# Write a char
		li $a0, 0x40
		li $v0, 11 # print char
		syscall

		jal red

		addi $a1, $a1, 0x1

		# Read the character back
		li $v0, 12 # read char
		syscall

		addi $a0, $s0, 0x0
		li $v0, 20
		syscall # Release mutex

		j t1

test2:
	addi $s0, $a0, 0x0
	li $a1, 0x0
	t2:
		addi $a0, $s0, 0x0
		li $v0, 19 # Acquire mutex
		syscall

		# Write a char
		li $a0, 0x41
		li $v0, 11 # print char
		syscall

		jal yellow

		addi $a1, $a1, 0x1

		# Read the character back
		li $v0, 12 # read char
		syscall

		addi $a0, $s0, 0x0
		li $v0, 20
		syscall # Release mutex

		j t2

test3:
	addi $s0, $a0, 0x0
	li $a1, 0x0
	t3:
		addi $a0, $s0, 0x0
		li $v0, 19 # Acquire mutex
		syscall

		# Write a char
		li $a0, 0x42
		li $v0, 11 # print char
		syscall

		jal green

		addi $a1, $a1, 0x1

		# Read the character back
		li $v0, 12 # read char
		syscall

		addi $a0, $s0, 0x0
		li $v0, 20
		syscall # Release mutex

		j t3
