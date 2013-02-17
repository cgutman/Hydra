.globl _general_exception_handler
.globl krnl_return_to_epc
.globl krnl_return_to_epc_next

.data

.text
krnl_return_to_epc:
	# Pop temps back
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	addi $sp, $sp, 0xC

	mfc0 $k1, $14 # Get EPC
	jr $k1 # replace PC with the return address

krnl_return_to_epc_next:
	# Pop temps back
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	addi $sp, $sp, 0xC

	mfc0 $k1, $14 # Get EPC
	addiu $k1, 0x4 # Next instruction
	jr $k1 # replace PC with the return address

_general_exception_handler:
	# Store a few temporaries for us to use
	addi $sp, $sp, -0xC
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)

	# Read the interrupt cause register
	mfc0 $t0, $13

	# Mask everything but the exception cause
	srl $t1, $t0, 2
	andi $t1, $t1, 0xF

	# Check if it's an interrupt
	beq $t1, $zero, interrupt

	# Check for a syscall request
	li $t2, 8
	beq $t1, $t2, syscallreq

	# Check if it's an illegal load
	li $t2, 4
	beq $t1, $t2, badload

	# Check for illegal store
	li $t2, 5
	beq $t1, $t2, badstore

	# Check for instruction bus error
	li $t2, 6
	beq $t1, $t2, ifetch

	# Check for data bus error
	li $t2, 7
	beq $t1, $t2, dbus

	# Check for breakpoint
	li $t2, 9
	beq $t1, $t2, breakpoint

	# Check for reserved instruction
	li $t2, 10
	beq $t1, $t2, reservedinst

	# Check for coprocessor missing
	li $t2, 11
	beq $t1, $t2, coprocmissing

	# Check for arithmetic exception
	li $t2, 12
	beq $t1, $t2, arithmetic

	# Unknown exception type
	jal krnl_fubar

interrupt:
	# Start determining the cause
	srl $t1, $t0, 8

	# Try the software interrupts first
	li $t2, 1
	beq $t1, $t2, krnl_softint_0
	li $t2, 2
	beq $t1, $t2, krnl_softint_1

	# Now hardware interrupts
	li $t2, 4
	beq $t1, $t2, krnl_hardint_2
	li $t2, 8
	beq $t1, $t2, krnl_hardint_3
	li $t2, 16
	beq $t1, $t2, krnl_hardint_4
	li $t2, 32
	beq $t1, $t2, krnl_hardint_5
	li $t2, 64
	beq $t1, $t2, krnl_hardint_6
	li $t2, 128
	beq $t1, $t2, krnl_hardint_7

	# If we're still here, something odd happened
	jal krnl_fubar

breakpoint:
	# We can just return to the next instruction
	j krnl_return_to_epc_next

syscallreq:
	# Not supported yet
	jal krnl_fubar

badload:
badstore:
ifetch:
dbus:
reservedinst:
coprocmissing:
arithmetic:
	# Fatal exceptions (for kernel mode)
	jal krnl_fubar
