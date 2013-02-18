.globl krnl_return_to_epc
.globl krnl_return_to_epc_next
.globl krnl_exception_init

.data

.section .app_excpt,"ax",@progbits
.align 12
.skip 0x180
krnl_exception:
	la $k0, krnl_exception_handler
	jr $k0
.align 0

.text
krnl_return_to_epc:
	# Pop temps back
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $a0, 12($sp)
	addi $sp, $sp, 0x10

	eret # Return to EPC

krnl_return_to_epc_next:

	mfc0 $t0, $14 # Get EPC
	addiu $t0, 0x4 # Next instruction
	mtc0 $t0, $14 # Set EPC to next instruction

	# Pop temps back
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $a0, 12($sp)
	addi $sp, $sp, 0x10

	eret # Return to new EPC

krnl_exception_init:
	# Setup cause register
	li $t0, 0x00000000
	mtc0 $t0, $13

	# Setup status register
	li $t0, 0x00000000
	mtc0 $t0, $12

	# Setup ebase
	li $t0, 0x9D001000
	mtc0 $t0, $15, 1

	# Interrupts are ok now
	ei

	# Return
	li $v0, 0x0
	jr $ra

krnl_exception_handler:
	# Restore k0 after it was clobbered by the jump
	lw $k0, KRNL_CONTEXT_ADDR

	# Store a few temporaries for us to use
	addi $sp, $sp, -0x10
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $a0, 12($sp)

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
	andi $t1, $t1, 0xFF

	# Find the source
	li $a0, 0x0 # Interrupt number
	li $t0, 0x1 # Interrupt bit
	li $t2, 0x8 # Max interrupt
iloop:
	beq $a0, $t2, ispurious # Break if none were set

	beq $t1, $t0, krnl_interrupt_dispatch # Check if this is the one

	# Nope, get ready to loop again
	addi $a0, $a0, 0x1
	sll $t0, $t0, 0x1

	# Try the next one
	j iloop

ispurious:
	# Just return to EPC
	j krnl_return_to_epc

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
