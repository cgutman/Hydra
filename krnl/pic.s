.globl hal_enable_timer
.globl hal_disable_timer
.globl hal_get_timer_irq
.globl hal_clear_timer_interrupt

# int hal_get_timer_irq()
hal_get_timer_irq:
	li $v0, 0x02
	jr $ra

# void hal_enable_timer(int period)
hal_enable_timer:
	li $t0, 0xBF800800 # T2CON
	sw $zero, 0($t0) # Initialize T2CON

	li $t0, 0xBF800810 # TMR2
	sw $zero, 0($t0) # Initialize TMR2

	li $t0, 0xBF800820 # PR2
	sw $a0, 0($t0)

	li $t0, 0xBF8810B0 # IPC2
	li $t1, 0x04 # This generates IRQ 2
	sw $t1, 0($t0)

	li $t0, 0xBF881060 # IEC0
	li $t1, 0x100
	sw $t1, 0($t0)

	li $t0, 0xBF800800 # T2CON
	li $t1, 0x8000
	sw $t1, 0($t0)

	jr $ra

# void hal_clear_timer_interrupt()
hal_clear_timer_interrupt:
	li $t0, 0xBF881034 # IFS0CLR
	li $t1, 0x100 # Interrupt to clear
	sw $t1, 0($t0)

	jr $ra

# void hal_disable_timer()
hal_disable_timer:
	# TODO
	jr $ra
