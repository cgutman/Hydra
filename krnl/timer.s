.globl krnl_timer_init
.globl krnl_timer_set
.globl krnl_timer_interrupt

.set noat

#
# Timer structure
#
# 0x00 - Signalled
# 0x04 - Period (in HW ticks)
# 0x08 - Periodic interval
# 0x0C - Next timer
#

.text
# void krnl_timer_init(void* timer)
krnl_timer_init:
	sw $zero, 0($a0) # Not signalled
	sw $zero, 4($a0) # No period yet
	sw $zero, 8($a0) # Not periodic
	sw $zero, 12($a0) # Not linked
	jr $ra

# void krnl_timer_set(void* timer, int periodIn100us, int periodic)
krnl_timer_set:
	# Push return address and s0 onto stack
	addi $sp, $sp, -0xC
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)

	# Not periodic for now
	sw $zero, 8($a0)

	# Save parameters
	addi $s0, $a0, 0x0
	addi $s1, $a1, 0x0
	addi $s2, $a2, 0x0

	# Compute actual timer period
	jal hal_get_ticks_per_100us
	mul $s1, $s1, $v0
	sw $s1, 4($s0)

	# Check if periodicity needs to be set
	beq $s2, $zero, dontsetperiodic

	# Yes, also write adjusted period to periodic field
	sw $s1, 8($s0)

dontsetperiodic:
	# Acquire timer spinlock to link
	addi $a0, $k0, 0x40
	jal krnl_spinlock_acquire

	# Link us to the head of the timer list
	lw $t0, 0x48($k0)
	sw $t0, 0x0C($s0)
	sw $s0, 0x48($k0)

	# Check to see if this period happens sooner
	lw $t1, 4($s0)
	lw $t2, 0x44($k0)
	slt $t0, $t1, $t2
	beq $t0, $zero, donetimerset # Not sooner, we're done

	# This timer happens before the next one, so we need to
	# reconfigure the timer to interrupt at this period

	# Set the next timer expiration period to this timer's period
	sw $t1, 0x44($k0)

	# Set the timer to this timer's period
	addi $a0, $t1, 0x0
	jal hal_reconfigure_timer

donetimerset:
	# Release the timer spinlock
	addi $a0, $k0, 0x40
	jal krnl_spinlock_release

	# Pop registers off stack
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	lw $s1, 8($sp)
	addi $sp, $sp, 0xC

	# Return
	jr $ra

# int krnl_timer_init()
krnl_timers_init:
	# Push return address onto the stack
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Initialize the timer spinlock
	addi $a0, $k0, 0x40
	jal krnl_spinlock_init

	# Timer list is empty
	sw $zero, 0x44($k0)

	# Query the timer interrupt
	jal hal_get_timer_irq

	# Register for the timer interrupt
	addi $a0, $v0, 0x0
	la $a1, krnl_timer_interrupt
	jal krnl_register_interrupt

	# Query required tick count
	jal krnl_get_ticks_per_100us

	# Start the timer
	li $a0, $v0, 0x0
	jal hal_enable_timer

	# Pop return address
	lw $ra, 0($sp)
	addi $sp, $sp, 0x4

	# Success
	li $v0, 0x0
	jr $ra

# void krnl_timer_interrupt()
# Only t0, t1, t2, and a0 are available
krnl_timer_interrupt:
	# Save the return address to stack
	addi $sp, $sp, -0x4
	sw $ra, 0($sp)

	# Start looping through timers at the head
	li $t2, 0xFFFFFFFF
	lw $t0, 0x48($k0)
nexttmrloop:
	beq $t0, $zero, nextdone # Check if we're at the end of the list

	# Subtract this timer period from each timer's period
	lw $t1, 0x04($t0)
	lw $a0, 0x44($k0)
	subu $t1, $t1, $a0
	sw $t1, 0x04($t0)

	# Check if this expired
	bne $t1, $zero, smallestcalc

	# It did, now we need to remove it if it's not periodic
	lw $t1, 0x08($t0)
	bne $t1, $zero, smallestcalc

	# Remove it
	

smallestcalc:
	# Compare this period to the last timer's period
	lw $t1, 0x04($t0)
	sltu $t1, $t1, $t2
	beq $t1, $zero, nextconttmr # Not less, just loop again

	# This is less than the smallest period, now it's the smallest
	addi $t2, $t1, 0x0

nextconttmr:
	# Load the next timer
	lw $t0, 0x0C($t0)

	# Loop again
	j tmrloop

nextdone:
	# Write the final next expiration period
	sw $t2, 0x44($k0)

	# Reset the timer
	jal krnl_clear_timer_interrupt

	# Reconfigure the timer to this expiration period
	addi $a0, $t2, 0x0
	jal krnl_reconfigure_timer

	# Pop the return address
	lw $ra, 0($sp)
	addi $sp, $sp, 0x4

	# Return
	j krnl_return_to_epc
