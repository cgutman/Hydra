.globl krnl_disable_interrupts
.globl krnl_restore_interrupts
.globl krnl_register_interrupt
.globl krnl_unregister_interrupt
.globl krnl_request_softint

.globl krnl_interrupt_dispatch

.data

.text

# void krnl_request_softint(int interrupt)
krnl_request_softint:
	li $t2, 0x1 # Setup bitshift
	sllv $t2, $t2, $a0 # Shift left a0 times
	sll $t2, $t2, 8 # Shift 8 more times

	di # Disable interrupts
	mfc0 $t0, $13 # Load cause reg
	or $t0, $t0, $t2 # Set the interrupt request bit
	mtc0 $t0, $13 # Store cause reg
	ei # Reenable interrupts

	jr $ra # Return

# void krnl_register_interrupt(int interrupt, void* ISR)
krnl_register_interrupt:
	addi $t0, $k0, 0x0 # Load interrupt vector address
	sll $t1, $a0, 2 # Shift left twice to get offset
	add $t0, $t0, $t1 # Get the vector address
	sw $a1, 0($t0) # Store the address to the ISR

	li $t2, 0x1 # Setup bitshift
	sllv $t2, $t2, $a0 # Shift left a0 times
	sll $t2, $t2, 8 # Shift 8 more times

	di # Disable interrupts while setting up status reg
	mfc0 $t0, $12 # Load status reg
	or $t0, $t0, $t2 # Set the interrupt enable bit
	mtc0 $t0, $12 # Store status reg
	ei # Reenable interrupts

	jr $ra # Return
	

# int krnl_unregister_interrupt(int interrupt)
krnl_unregister_interrupt:
	li $t2, 0x1 # Setup bitshift
	sllv $t2, $t2, $a0 # Shift left a0 times
	not $t2, $t2 # Invert t2 to mask it

	di # Disable interrupts while setting up status reg
	mfc0 $t0, $12 # Load status reg
	and $t0, $t0, $t2 # Mask the interrupt enable bit
	mtc0 $t0, $12 # Store status reg
	ei # Reenable interrupts

	jr $ra # Return

# int krnl_disable_interrupts()
krnl_disable_interrupts:
	# Load the PCR
	lw $t0, 0x74($k1)

	# Load the old interrupt state into the return register
	lw $v0, 0x10($t0)

	# Disable interrupts
	sw $zero, 0x10($t0)

	# Write it to hardware
	di

	jr $ra # Return

# void krnl_restore_interrupts(int oldstate)
krnl_restore_interrupts:
	# Load the PCR
	lw $t0, 0x74($k1)

	# Write the old state back
	sw $a0, 0x10($t0)

	# Check if interrupts can be enabled
	beq $a0, $zero, ret

	# Enable interrupts
	ei

ret:
	jr $ra # Return

# krnl_interrupt_dispatch(int interrupt)
# NOTE: Only t0, t1, t2, and a0 are writable
krnl_interrupt_dispatch:
	lw $t0, KRNL_CONTEXT_ADDR # Load the interrupt vector table pointer
	sll $t1, $a0, 2 # Get the offset to the vector pointer
	add $t0, $t0, $t1 # Add them to get the address of the vector pointer
	lw $t0, 0($t0) # Load the vector
	jr $t0 # Call the vector
