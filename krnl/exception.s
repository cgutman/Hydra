.globl krnl_return_to_epc
.globl krnl_return_to_epc_next
.globl krnl_exception_init

.set noat

.data

.section .app_excpt,"ax",@progbits
.align 12
.skip 0x180
krnl_exception:
	la $k0, krnl_exception_handler
	jr $k0

.skip 0x70
krnl_interrupt:
	la $k0, krnl_interrupt_handler
	jr $k0
.align 0

.text
nestedexcret:
	# Pop temps back
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $a0, 12($sp)

	# Pop the old status value off the stack
	lw $k0, 20($sp)
	addi $sp, $sp, 0x18

	# Write the old status value back
	ori $k0, $k0, 0x2 # EXL bit is set
	mtc0 $k0, $12
	ehb

	# Restore k0
	lw $k0, KRNL_CONTEXT_ADDR

	# We don't jump back to user-mode stack
	eret

krnl_return_to_epc:
	# Reenter EXL
	mfc0 $t0, $12
	ori $t0, $t0, 0x2
	mtc0 $t0, $12
	ehb

	# Pop the EPC off the stack
	lw $t0, 16($sp)
	mtc0 $t0, $14 # Set EPC

	# Check if this is a nested exception
	addi $t0, $sp, 0x18
	addi $t1, $k1, 0x190
	bne $t1, $t0, nestedexcret

	# Unset exception active
	sw $zero, 0x8C($k1)

	# Pop temps back
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $a0, 12($sp)

	# Pop the old status value off the stack
	lw $k0, 20($sp)
	addi $sp, $sp, 0x18

	# Write the old status value back
	ori $k0, $k0, 0x2 # EXL bit is set
	mtc0 $k0, $12
	ehb

	# Switch back to user-mode thread stack
	lw $sp, 0x194($k1)

	# Restore k0
	lw $k0, KRNL_CONTEXT_ADDR

	eret

krnl_return_to_epc_next:
	# Reenter EXL
	mfc0 $t0, $12
	ori $t0, $t0, 0x2
	mtc0 $t0, $12
	ehb

	# Pop the EPC off the stack
	lw $t0, 16($sp)
	addiu $t0, 0x4 # Next instruction
	mtc0 $t0, $14 # Set EPC to next instruction

	# Check if this is a nested exception
	addi $t0, $sp, 0x18
	addi $t1, $k1, 0x190
	bne $t1, $t0, nestedexcret

	# Unset exception active
	sw $zero, 0x8C($k1)

	# Pop temps back
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $a0, 12($sp)

	# Pop the old status value off the stack
	lw $k0, 20($sp)
	addi $sp, $sp, 0x18

	# Write the old status value back
	ori $k0, $k0, 0x2 # EXL bit is set
	mtc0 $k0, $12
	ehb

	# Restore k0
	lw $k0, KRNL_CONTEXT_ADDR

	# Switch back to user-mode thread stack
	lw $sp, 0x194($k1)

	eret

krnl_exception_init:
	# Setup cause register
	li $t0, 0x00800000
	mtc0 $t0, $13

	# Setup status register
	li $t0, 0x00000003 # EXL and IE set
	mtc0 $t0, $12

	# Setup ebase
	li $t0, 0x9D001000
	mtc0 $t0, $15, 1

	# Setup IntCtl
	li $t0, 0x00000000
	mtc0 $t0, $12, 1

	# Return
	li $v0, 0x0
	jr $ra

krnl_interrupt_handler:
	# Check if an exception is already active
	lw $k0, 0x8C($k1)
	bne $k0, $zero, interrupt_resume # Yes!

	# Switch to kernel-mode thread stack
	sw $sp, 0x194($k1)
	addi $sp, $k1, 0x190

	# Exception is active
	li $k0, 0x01
	sw $k0, 0x8C($k1)

interrupt_resume:
	# Save the status register
	addi $sp, $sp, -0x4
	mfc0 $k0, $12
	sw $k0, 0($sp)

	# Save the EPC register
	mfc0 $k0, $14
	addi $sp, $sp, -0x4
	sw $k0, 0($sp)

	# Restore k0
	lw $k0, KRNL_CONTEXT_ADDR

	# Store a few temporaries for us to use
	addi $sp, $sp, -0x10
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $a0, 12($sp)

	# Read the cause register
	mfc0 $t0, $13

	# Mask the cause register
	li $t1, 0xFFFF00FF
	and $t1, $t0, $t1
	mtc0 $t1, $13

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

krnl_exception_handler:
	# Check if an exception is already active
	lw $k0, 0x8C($k1)
	bne $k0, $zero, exception_resume # Yes!

	# Switch to kernel-mode thread stack
	sw $sp, 0x194($k1)
	addi $sp, $k1, 0x190

	# Exception is active
	li $k0, 0x01
	sw $k0, 0x8C($k1)

exception_resume:
	# Save the status register
	mfc0 $k0, $12
	addi $sp, $sp, -0x4
	sw $k0, 0($sp)

	# Save the EPC register
	mfc0 $k0, $14
	addi $sp, $sp, -0x4
	sw $k0, 0($sp)

	# Restore k0
	lw $k0, KRNL_CONTEXT_ADDR

	# Store a few temporaries for us to use
	addi $sp, $sp, -0x10
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $a0, 12($sp)

	# Read the cause register
	mfc0 $t0, $13

	# Mask everything but the exception cause
	srl $t1, $t0, 2
	andi $t1, $t1, 0xF

	# Check for a syscall request
	li $t2, 8
	beq $t1, $t2, syscallreq

	# Check for breakpoint
	li $t2, 9
	beq $t1, $t2, breakpoint

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

breakpoint:
	# We can just return to the next instruction
	j krnl_return_to_epc_next

syscallreq:
	# Call the syscall dispatcher
	j krnl_syscall_dispatch

badload:
badstore:
ifetch:
dbus:
reservedinst:
coprocmissing:
arithmetic:
	# Terminate the thread
	j krnl_user_thread_exception
