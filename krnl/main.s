.globl main

.data

.text
main:
	# Initialize the kernel
	jal krnl_init

	# Initialize the spinlock
	li $a0, 0xA0000300
	jal krnl_spinlock_init

	# Start a new thread
	la $a0, test2
	jal krnl_create_thread

test1:
	t1:
		li $a0, 0xA0000300
		#jal krnl_spinlock_acquire

		jal krnl_sleep_thread

		li $a0, 0xA0000300
		#jal krnl_spinlock_release

		#jal krnl_sleep_thread

		j t1

test2:
	t2:
		li $a0, 0xA0000300
		#jal krnl_spinlock_acquire

		jal krnl_sleep_thread

		li $a0, 0xA0000300
		#jal krnl_spinlock_release

		jal krnl_sleep_thread

		j t2

loop:
	j loop
