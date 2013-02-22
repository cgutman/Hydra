.globl main

.data

.text
main:
	# Initialize the kernel
	jal krnl_init

	# Initialize the LEDs
	jal init

	# Initialize the mutex
	li $a0, 0x80004000
	li $v0, 22 # mutex init
	syscall

	# Start a new thread
	la $a0, test1
	li $a1, 0x80004000
	li $v0, 21 # create thread
	syscall

	# This is the idle thread
idle:

	# Look for another thread to execute
	li $v0, 18 # Sleep syscall
	syscall

	# We're back, just try again
	j idle

test1:

	# Spawn a second thread
	addi $a1, $a0, 0x0 # Copy the lock pointer
	la $a0, test2
	li $v0, 21 # Create thread
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

		jal red

		addi $a1, $a1, 0x1

		li $v0, 18 # Sleep syscall
		syscall

		addi $a1, $a1, 0x1

		break

		jal clearRed

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

		jal yellow

		addi $a1, $a1, 0x1

		li $v0, 18 # Sleep syscall
		syscall

		addi $a1, $a1, 0x1

		jal clearYellow

		break

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

		jal green

		addi $a1, $a1, 0x1

		li $v0, 18 # Sleep syscall
		syscall

		addi $a1, $a1, 0x1

		jal clearGreen

		break

		addi $a0, $s0, 0x0
		li $v0, 20
		syscall # Release mutex

		j t3
