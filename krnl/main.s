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

test00:
	li $a0, 0x10
	li $a1, 0x11
	li $a2, 0x12
	li $a3, 0x13
	li $s0, 0x10
	li $s1, 0x11
	li $s2, 0x12
	li $s3, 0x13
	li $s4, 0x14
	li $s5, 0x15
	li $s6, 0x16
	li $s7, 0x17
	li $t0, 0x10
	li $t1, 0x11
	li $t2, 0x12
	li $t3, 0x13
	li $t4, 0x14
	li $t5, 0x15
	li $t6, 0x16
	li $t7, 0x17
	li $v0, 0x10
	li $v1, 0x11
	li $fp, 0x1BEEF

	j test00

test0:
	# Spawn a second thread

	la $a0, test00
	jal krnl_create_thread

t0:
	li $a0, 0x0
	li $a1, 0x1
	li $a2, 0x2
	li $a3, 0x3
	li $s0, 0x0
	li $s1, 0x1
	li $s2, 0x2
	li $s3, 0x3
	li $s4, 0x4
	li $s5, 0x5
	li $s6, 0x6
	li $s7, 0x7
	li $t0, 0x0
	li $t1, 0x1
	li $t2, 0x2
	li $t3, 0x3
	li $t4, 0x4
	li $t5, 0x5
	li $t6, 0x6
	li $t7, 0x7
	li $v0, 0x0
	li $v1, 0x1
	li $fp, 0xBEEF

	j t0

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

		syscall

		addi $a1, $a1, 0x1

		break

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

		syscall

		addi $a1, $a1, 0x1

		jal clearYellow

		break

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

		syscall

		addi $a1, $a1, 0x1

		jal clearGreen

		break

		addi $a0, $s0, 0x0
		jal krnl_mutex_release

		j t3
