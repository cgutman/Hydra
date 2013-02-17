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
	jal krnl_create_thread

	# This is the idle thread
idle:

	# Look for another thread to execute
	jal krnl_sleep_thread

	# We're back, just try again
	j idle

test1:

	# Spawn a second thread
	la $a0, test2
	jal krnl_create_thread

	# Spawn a third thread
	la $a0, test3
	jal krnl_create_thread

	li $a1, 0x0

	t1:
		li $a0, 0x80004000
		jal krnl_mutex_acquire

		jal red

		addi $a1, $a1, 0x1

		jal krnl_sleep_thread

		addi $a1, $a1, 0x1

		jal clearRed

		li $a0, 0x80004000
		jal krnl_mutex_release

		j t1

test2:
	li $a1, 0x0
	t2:
		li $a0, 0x80004000
		jal krnl_mutex_acquire

		jal yellow

		addi $a1, $a1, 0x1

		jal krnl_sleep_thread

		addi $a1, $a1, 0x1

		jal clearYellow

		li $a0, 0x80004000
		jal krnl_mutex_release

		j t2

test3:
	li $a1, 0x0
	t3:
		li $a0, 0x80004000
		jal krnl_mutex_acquire

		jal green

		addi $a1, $a1, 0x1

		jal krnl_sleep_thread

		addi $a1, $a1, 0x1

		jal clearGreen

		li $a0, 0x80004000
		jal krnl_mutex_release

		j t3
