.globl main

.data

.text
main:
	# Initialize the kernel
	jal krnl_init

	# Initialize the mutex
	li $a0, 0xA0000300
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

	li $a0, 0x0

	t1:
		li $a0, 0xA0000300
		jal krnl_mutex_acquire

		addi $a0, $a0, 0x1

		jal krnl_sleep_thread

		addi $a0, $a0, 0x1

		li $a0, 0xA0000300
		jal krnl_mutex_release

		j t1

test2:
	li $a1, 0x0
	t2:
		li $a0, 0xA0000300
		jal krnl_mutex_acquire

		addi $a1, $a1, 0x1

		jal krnl_sleep_thread

		addi $a1, $a1, 0x1

		li $a0, 0xA0000300
		jal krnl_mutex_acquire

		li $a0, 0xA0000300
		jal krnl_mutex_release

		j t2
