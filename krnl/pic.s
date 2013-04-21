.globl hal_enable_timer
.globl hal_disable_timer
.globl hal_get_timer_irq
.globl hal_clear_timer_interrupt
.globl hal_enter_low_power_mode
.globl hal_exit_low_power_mode
.globl hal_reconfigure_timer
.globl hal_get_ticks_per_100us

# void hal_enter_low_power_mode()
hal_enter_low_power_mode:
	# Set the reduced power bit
	li $t1, 0x08000000

	# Write this bit to CP0
	mfc0 $t0, $12
	or $t0, $t0, $t1
	mtc0 $t0, $12

	# Return
	jr $ra

# void hal_exit_low_power_mode()
hal_exit_low_power_mode:
	# Mask the reduced power bit
	li $t1, 0xF7FFFFFF

	# Write this bit to CP0
	mfc0 $t0, $12
	and $t0, $t0, $t1
	mtc0 $t0, $12

	# Return
	jr $ra

# int hal_get_ticks_per_100us
hal_get_ticks_per_100us:
	li $v0, 8000
	jr $ra

# int hal_get_timer_irq()
hal_get_timer_irq:
	li $v0, 0x02
	jr $ra

# void hal_reconfigure_timer(int period)
hal_reconfigure_timer:
	li $t0, 0xBF800820 # PR2
	sw $a0, 0($t0)

	jr $ra

# void hal_enable_timer(int period)
hal_enable_timer:
	li $t0, 0xBF800800 # T2CON
	sw $zero, 0($t0) # Initialize T2CON

	li $t0, 0xBF800810 # TMR2
	sw $zero, 0($t0) # Initialize TMR2

	li $t0, 0xBF800820 # PR2
	sw $a0, 0($t0)

	li $t0, 0xBF8810B4 # IPC2CLR
	li $t1, 0x1F
	sw $t1, 0($t0)

	li $t0, 0xBF8810B8 # IPC2SET
	li $t1, 0x04 # This generates IRQ 2
	sw $t1, 0($t0)

	li $t0, 0xBF881068 # IEC0SET
	li $t1, 0x100
	sw $t1, 0($t0)

	li $t0, 0xBF800800 # T2CON
	li $t1, 0x8000
	sw $t1, 0($t0)

	jr $ra

# void hal_clear_timer_interrupt()
hal_clear_timer_interrupt:
	# Disable the timer
	li $t0, 0xBF800804 # T2CONCLR
	li $t1, 0x8000
	sw $t1, 0($t0)

	# Clear the current timer value
	li $t0, 0xBF800814 # TMR2
	li $t1, 0xFFFFFFFF # Timer mask
	sw $t1, 0($t0)

	# Clear the interrupt status bit
	li $t0, 0xBF881034 # IFS0CLR
	li $t1, 0x100
	sw $t1, 0($t0)

	# Reenable the timer
	li $t0, 0xBF800800 # T2CON
	li $t1, 0x8000
	sw $t1, 0($t0)

	jr $ra

# void hal_disable_timer()
hal_disable_timer:
	# Disable timer interrupts
	li $t0, 0xBF881064 # IEC0CLR
	li $t1, 0x100
	sw $t1, 0($t0)

	# Disable the timer
	li $t0, 0xBF800804 # T2CONCLR
	li $t1, 0x8000
	sw $t1, 0($t0)

	# Clear the interrupt status bit
	li $t0, 0xBF881034 # IFS0CLR
	li $t1, 0x100
	sw $t1, 0($t0)

	jr $ra
