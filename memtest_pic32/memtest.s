.data
	.globl main

.text
main:
	jal init # Run init code

	jal yellow # Set the "in progress" LED

retest:
	li $a0, 0xA0000000 # Start address for RAM in PIC32MX360F512L
	li $a1, 0xA0008000 # End address for RAM

	# These don't modify a0 or a1 so they can be called consecutively
	jal allzero
	beq $v0, $zero, fail
	jal allone
	beq $v0, $zero, fail
	jal addrfill
	beq $v0, $zero, fail
	jal invaddrfill
	beq $v0, $zero, fail

success:
	jal green # Set "success" LED
	j retest # Jump to start again

fail:
	jal clearYellow # Clear "in progress" LED
	jal clearGreen # Clear "success" LED
	jal red # Set "failure" LED
	j eloop # Jump to end loop

eloop:
	j eloop # Loop forever

allzero:
	addi $t0, $a0, 0x0 # Init t0 to address start (a0)
	li $t1, 0x00000000 # Init t1 to the fill (all 0)

	zloop:
		sw $t1, 0($t0) # Store the fill to the current address
		addi $t0, $t0, 0x4 # Increment address by 4 bytes
		bne $t0, $a1, zloop # Loop until the end address is reached

	addi $t0, $a0, 0x0 # Reinit t0 to address start (a0)
	zcheck:
		lw $t2, 0($t0) # Load the current address into t2
		bne $t2, $t1, zfail # Jump out if the value is wrong
		addi $t0, $t0, 0x4 # Increment address by 4 bytes
		bne $t0, $a1, zcheck # Loop until end address is reached

	zsuccess:
		li $v0, 0x1 # 1 means success
		jr $ra # Return

	zfail:
		li $v0, 0x0 # 0 means failure
		jr $ra # Return

allone:
	addi $t0, $a0, 0x0 # Init t0 to address start (a0)
	li $t1, 0xFFFFFFFF # Init t1 to the fill (all 1)

	floop:
		sw $t1, 0($t0) # Store the fill to the current address
		addi $t0, $t0, 0x4 # Increment address by 4 bytes
		bne $t0, $a1, floop # Loop until the end address is reached

	addi $t0, $a0, 0x0 # Reinit t0 to address start (a0)
	fcheck:
		lw $t2, 0($t0) # Load the current address into t2
		bne $t2, $t1, ffail # Jump out if the value is wrong
		addi $t0, $t0, 0x4 # Increment address by 4 bytes
		bne $t0, $a1, fcheck # Loop until end address is reached

	fsuccess:
		li $v0, 0x1 # 1 means success
		jr $ra # Return

	ffail:
		li $v0, 0x0 # 0 means failure
		jr $ra # Return

addrfill:
	addi $t0, $a0, 0x0 # Init t0 to address start (a0)

	aloop:
		sw $t0, 0($t0) # Store the fill to the current address
		addi $t0, $t0, 0x4 # Increment address by 4 bytes
		bne $t0, $a1, aloop # Loop until the end address is reached

	addi $t0, $a0, 0x0 # Reinit t0 to address start (a0)
	acheck:
		lw $t2, 0($t0) # Load the current address into t2
		bne $t2, $t0, afail # Jump out if the value is wrong
		addi $t0, $t0, 0x4 # Increment address by 4 bytes
		bne $t0, $a1, acheck # Loop until end address is reached

	asuccess:
		li $v0, 0x1 # 1 means success
		jr $ra # Return

	afail:
		li $v0, 0x0 # 0 means failure
		jr $ra # Return

invaddrfill:
	addi $t0, $a0, 0x0 # Init t0 to address start (a0)

	ialoop:
		nor $t1, $t0, $zero # Invert the current address
		sw $t1, 0($t0) # Store the fill to the current address
		addi $t0, $t0, 0x4 # Increment address by 4 bytes
		bne $t0, $a1, ialoop # Loop until the end address is reached

	addi $t0, $a0, 0x0 # Reinit t0 to address start (a0)
	iacheck:
		nor $t1, $t0, $zero # Invert the current address
		lw $t2, 0($t0) # Load the current address into t2
		bne $t2, $t1, iafail # Jump out if the value is wrong
		addi $t0, $t0, 0x4 # Increment address by 4 bytes
		bne $t0, $a1, iacheck # Loop until end address is reached

	iasuccess:
		li $v0, 0x1 # 1 means success
		jr $ra # Return

	iafail:
		li $v0, 0x0 # 0 means failure
		jr $ra # Return
