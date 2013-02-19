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
	jal krnl_mutex_init

	# Start a new thread
	la $a0, test1
	li $a1, 0x80004000
	jal krnl_create_thread

	# This is the idle thread
idle:

	# Look for another thread to execute
	jal krnl_sleep_thread

	# We're back, just try again
	j idle

test1:

	# Spawn a second thread
	addi $a1, $a0, 0x0 # Copy the lock pointer
	la $a0, test2
	jal krnl_create_thread

	# Spawn a third thread
	la $a0, test3
	jal krnl_create_thread

	addi $s0, $a1, 0x0
	li $a1, 0x0

	t1:
		addi $a0, $s0, 0x0
		jal krnl_mutex_acquire

		jal red

		addi $a1, $a1, 0x1

		#syscall

		addi $a1, $a1, 0x1

		#break

		jal clearRed

		addi $a0, $s0, 0x0
		jal krnl_mutex_release

		j t1

test2:
	addi $s0, $a0, 0x0
	li $a1, 0x0
	t2:
		addi $a0, $s0, 0x0
		jal krnl_mutex_acquire

		jal yellow

		addi $a1, $a1, 0x1

		#syscall

		addi $a1, $a1, 0x1

		jal clearYellow

		#break

		addi $a0, $s0, 0x0
		jal krnl_mutex_release

		j t2

test3:
	addi $s0, $a0, 0x0
	li $a1, 0x0
	t3:
		addi $a0, $s0, 0x0
		jal krnl_mutex_acquire

		jal green

		addi $a1, $a1, 0x1

		#syscall

		addi $a1, $a1, 0x1

		jal clearGreen

		#break

		addi $a0, $s0, 0x0
		jal krnl_mutex_release

		j t3
