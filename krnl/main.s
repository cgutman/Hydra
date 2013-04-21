.globl main

.data
hi:
.asciiz "Welcome to Hydra\r\n"

cr:
.ascii "\r"

lf:
.ascii "\n"

.text
main:
	# Initialize the kernel
	la $a0, userstart
	jal krnl_init

userstart:
	# Print a hello
	la $a0, hi
	li $v0, 4
	syscall

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
	# Read a character in
	la $v0, 12
	syscall
	addi $s0, $v0, 0x0

	# Write the character back out
	addi $a0, $s0, 0x0
	li $v0, 11
	syscall

	# Write the character to SPI
	addi $a0, $s0, 0x0
	jal hal_spi_write

	# If this is a carriage return, add a line feed
	la $t0, cr
	lb $t1, 0($t0)
	bne $s0, $t1, loop
	la $t0, lf
	lb $a0, 0($t0)
	li $v0, 11
	syscall

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

		jal hal_xmips_blink_r

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

		jal hal_xmips_blink_g

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

		jal hal_xmips_blink_b

		addi $a0, $s0, 0x0
		li $v0, 20
		syscall # Release mutex

		j t3
