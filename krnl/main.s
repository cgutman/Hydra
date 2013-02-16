.globl main

.data

.text
main:
	# Initialize the kernel
	jal krnl_init

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

	# Spawn a fourth thread
	la $a0, test4
	jal krnl_create_thread

	# Spawn a fifth thread
	la $a0, test5
	jal krnl_create_thread

	# Spawn a sixth thread
	la $a0, test6
	jal krnl_create_thread

	li $a1, 0x0

	t1:
		li $a0, 0x80004000
		jal krnl_mutex_acquire

		addi $a1, $a1, 0x1

		jal krnl_sleep_thread

		addi $a1, $a1, 0x1

		li $a0, 0x80004000
		jal krnl_mutex_release

		j t1

test2:
	li $a1, 0x0
	t2:
		li $a0, 0x80004000
		jal krnl_mutex_acquire

		addi $a1, $a1, 0x1

		jal krnl_sleep_thread

		addi $a1, $a1, 0x1

		li $a0, 0x80004000
		jal krnl_mutex_release

		j t2

test3:
	li $a1, 0x0
	t3:
		li $a0, 0x80004000
		jal krnl_mutex_acquire

		addi $a1, $a1, 0x1

		jal krnl_sleep_thread

		addi $a1, $a1, 0x1

		li $a0, 0x80004000
		jal krnl_mutex_release

		j t3

test4:
	li $a1, 0x0
	t4:
		li $a0, 0x80004000
		jal krnl_mutex_acquire

		addi $a1, $a1, 0x1

		jal krnl_sleep_thread

		addi $a1, $a1, 0x1

		li $a0, 0x80004000
		jal krnl_mutex_release

		j t4

test5:
	li $a1, 0x0
	t5:
		li $a0, 0x80004000
		jal krnl_mutex_acquire

		addi $a1, $a1, 0x1

		jal krnl_sleep_thread

		addi $a1, $a1, 0x1

		li $a0, 0x80004000
		jal krnl_mutex_release

		j t5

test6:
	li $a1, 0x0
	t6:
		li $a0, 0x80004000
		jal krnl_mutex_acquire

		addi $a1, $a1, 0x1

		jal krnl_sleep_thread

		addi $a1, $a1, 0x1

		li $a0, 0x80004000
		jal krnl_mutex_release

		j t6
