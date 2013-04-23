.globl krnl_syscall_dispatch
.globl krnl_syscall_init

.data

.text

.set noat # $at is not saved when we enter

# This is a simple syscall stub at ordinal 0
krnl_syscall_null:
	jr $ra

krnl_syscall_init:
	# Build the syscall table
	addi $t1, $k0, 0x40

	# Ordinal 0 - Nop
	la $t0, krnl_syscall_null
	sw $t0, 0x00($t1)

	# Ordinal 1 - print_int (SPIM)
	la $t0, krnl_io_write_int
	sw $t0, 0x04($t1)

	# Ordinal 2 - print_float (SPIM)
	la $t0, krnl_io_write_float
	sw $t0, 0x08($t1)

	# Ordinal 3 - print_double (SPIM)
	la $t0, krnl_io_write_double
	sw $t0, 0x0C($t1)

	# Ordinal 4 - print_string (SPIM)
	la $t0, krnl_io_write_string
	sw $t0, 0x10($t1)

	# Ordinal 5 - read_int (SPIM)
	la $t0, krnl_io_read_int
	sw $t0, 0x14($t1)

	# Ordinal 6 - read_float (SPIM)
	la $t0, krnl_io_read_float
	sw $t0, 0x18($t1)

	# Ordinal 7 - read_double (SPIM)
	la $t0, krnl_io_read_double
	sw $t0, 0x1C($t1)

	# Ordinal 8 - read_string (SPIM)
	la $t0, krnl_io_read_string
	sw $t0, 0x20($t1)

	# Ordinal 9 - sbrk (SPIM)
	la $t0, krnl_user_alloc
	sw $t0, 0x24($t1)

	# Ordinal 10 - exit (SPIM)
	la $t0, krnl_terminate_thread
	sw $t0, 0x28($t1)

	# Ordinal 11 - print_character (SPIM)
	la $t0, krnl_io_write_char
	sw $t0, 0x2C($t1)

	# Ordinal 12 - read_character (SPIM)
	la $t0, krnl_io_read_char
	sw $t0, 0x30($t1)

	# Ordinal 13 - open (SPIM)
	la $t0, krnl_syscall_null
	sw $t0, 0x34($t1)

	# Ordinal 14 - read (SPIM)
	la $t0, krnl_syscall_null
	sw $t0, 0x38($t1)

	# Ordinal 15 - write (SPIM)
	la $t0, krnl_syscall_null
	sw $t0, 0x3C($t1)

	# Ordinal 16 - close (SPIM)
	la $t0, krnl_syscall_null
	sw $t0, 0x40($t1)

	# Ordinal 17 - exit2 (SPIM)
	la $t0, krnl_terminate_thread
	sw $t0, 0x44($t1)

	# Ordinal 18 - yield()
	la $t0, krnl_yield_thread
	sw $t0, 0x48($t1)

	# Ordinal 19 - mutex_acquire()
	la $t0, krnl_mutex_acquire
	sw $t0, 0x4C($t1)

	# Ordinal 20 - mutex_release()
	la $t0, krnl_mutex_release
	sw $t0, 0x50($t1)

	# Ordinal 21 - create_thread()
	la $t0, krnl_create_thread
	sw $t0, 0x54($t1)

	# Ordinal 22 - mutex_init()
	la $t0, krnl_mutex_init
	sw $t0, 0x58($t1)

	# Ordinal 23 - krnl_wait_for_thread()
	la $t0, krnl_wait_for_thread
	sw $t0, 0x5C($t1)

	# Write the next ordinal as the first invalid one
	li $t0, 24
	sw $t0, 0x3C($k0)

	jr $ra

krnl_syscall_dispatch:
	# Check that the syscall is valid
	lw $t0, 0x3C($k0)
	sltu $t0, $v0, $t0
	beq $t0, $zero, invalidsyscall

	# Enable interrupts by masking EXL and UM
	mfc0 $t0, $12
	li $t1, 0xFFFFFFED
	and $t1, $t0, $t1
	mtc0 $t1, $12
	ehb

	# Save the old status reg
	addi $sp, $sp, -0x4
	sw $t0, 0($sp)

	# Convert the ordinal to a pointer
	sll $t0, $v0, 2 # Shift by 2 to get a pointer offset
	add $t0, $k0, $t0 # Add the offset of the kernel context
	lw $t0, 0x40($t0) # Load the address of the function

	# Save temporary variables (except t0 to t2) and return address
	addi $sp, $sp, -0x24
	sw $ra, 0($sp)
	sw $t3, 4($sp)
	sw $t4, 8($sp)
	sw $t5, 12($sp)
	sw $t6, 16($sp)
	sw $t7, 20($sp)
	sw $t8, 24($sp)
	sw $t9, 28($sp)
	sw $at, 32($sp)

	# Jump to the syscall
	jalr $t0

	# Restore temps and return address
	lw $ra, 0($sp)
	lw $t3, 4($sp)
	lw $t4, 8($sp)
	lw $t5, 12($sp)
	lw $t6, 16($sp)
	lw $t7, 20($sp)
	lw $t8, 24($sp)
	lw $t9, 28($sp)
	lw $at, 32($sp)
	addi $sp, $sp, 0x24

	# Restore status
	lw $t0, 0($sp)
	addi $sp, $sp, 0x4

	# Write old status back
	mtc0 $t0, $12
	ehb

	# Return to user-mode
	j krnl_return_to_epc_next

invalidsyscall:
	jal krnl_fubar
