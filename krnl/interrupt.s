.globl krnl_disable_interrupts
.globl krnl_restore_interrupts
.globl krnl_register_interrupt
.globl krnl_unregister_interrupt
.globl krnl_softint_0
.globl krnl_softint_1
.globl krnl_hardint_2
.globl krnl_hardint_3
.globl krnl_hardint_4
.globl krnl_hardint_5
.globl krnl_hardint_6
.globl krnl_hardint_7

.data

.text

# void krnl_register_interrupt(int interrupt, void* ISR)
krnl_register_interrupt:
	li $t0, 0x80004000 # Load interrupt vector address
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
	addi $t0, $k1, 0x74
	lw $t0, 0($t0)

	# Load the old interrupt state into the return register
	addi $t0, $t0, 0x10
	lw $v0, 0($t0)

	# Disable interrupts
	sw $zero, 0($t0)

	# Write it to hardware
	di

	jr $ra # Return

# void krnl_restore_interrupts(int oldstate)
krnl_restore_interrupts:
	# Load the PCR
	addi $t0, $k1, 0x74
	lw $t0, 0($t0)

	# Write the old state back
	addi $t0, $t0, 0x10
	sw $a0, 0($t0)

	# Check if interrupts can be enabled
	beq $a0, $zero, ret

	# Enable interrupts
	ei

ret:
	jr $ra # Return

# Interrupt handlers
krnl_softint_0:
	li $t0, 0x80006000 # Load interrupt vector address
	jr $t0 # Call it

krnl_softint_1:
	li $t0, 0x80006004 # Load interrupt vector address
	jr $t0 # Call it

krnl_hardint_2:
	li $t0, 0x80006008 # Load interrupt vector address
	jr $t0 # Call it

krnl_hardint_3:
	li $t0, 0x8000600C # Load interrupt vector address
	jr $t0 # Call it

krnl_hardint_4:
	li $t0, 0x80006010 # Load interrupt vector address
	jr $t0 # Call it

krnl_hardint_5:
	li $t0, 0x80006014 # Load interrupt vector address
	jr $t0 # Call it

krnl_hardint_6:
	li $t0, 0x80006018 # Load interrupt vector address
	jr $t0 # Call it

krnl_hardint_7:
	li $t0, 0x8000601C # Load interrupt vector address
	jr $t0 # Call it
