.globl hal_enable_timer
.globl hal_disable_timer
.globl hal_get_timer_irq
.globl hal_clear_timer_interrupt
.globl hal_enter_low_power_mode
.globl hal_exit_low_power_mode
.globl hal_init_hardware
.globl hal_uart_read
.globl hal_uart_write

.globl hal_xmips_blink_r
.globl hal_xmips_blink_g
.globl hal_xmips_blink_b

.data
hal_max_uart:
.word 0x04 # 3 UARTs (1 - 3)

# UART base addresses
hal_uart_base:
.word 0x0
.word 0xBF806000 # UART 1
.word 0xBF806800 # UART 2
.word 0xBF806A00 # UART 5

.text
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

# $a0 has bit to set
# $v0 has output
decodebit:
	li $v0, 0x1
decodeloop:
	beq $a0, $zero, decodedone
	sll $v0, $v0, 0x1
	addi $a0, $a0, -0x1
	j decodeloop
decodedone:
	jr $ra

# $a0 has address to set
setgbit:
	li $t0, 0xBF886198
	sw $a0, 0($t0)
	jr $ra

# $a0 has address to clear
cleargbit:
	li $t0, 0xBF886194
	sw $a0, 0($t0)
	jr $ra

waitforblinky:
	li $t0, 0x0
	li $t1, 0x10000
waitloop:
	beq $t0, $t1, waitend
	addi $t0, $t0, 0x1
	j waitloop
waitend:
	jr $ra

# void hal_init_hardware()
hal_init_hardware:
	# Set bits 12, 13, and 14 on TRISG to output (RGB LED)
	li $t0, 0xBF886184
	li $t1, 0x7000
    sw $t1, 0($t0)

	# ------ UART SETUP ------
	la $t0, hal_max_uart
	lw $t4, 0($t0) # Load the UART max
	li $t5, 1 # Start at UART 1
uart_setup_loop:
	beq $t5, $t4, uart_setup_done
	
	# Load the UART base
	la $t0, hal_uart_base
	sll $t3, $t5, 2
	add $t3, $t0, $t3
	lw $t3, 0($t3)

	# Clear the mode register
	addi $t0, $t3, 0x4 # UXMODECLR
	li $t1, 0xFFFFFFFF
	sw $t1, 0($t0)

	# Clear the status register
	addi $t0, $t3, 0x14 # UXSTACLR
	li $t1, 0xFFFFFFFF
	sw $t1, 0($t0)

	# Clear the baud register
	addi $t0, $t3, 0x44 # UXBRGCLR
	li $t1, 0xFFFFFFFF
	sw $t1, 0($t0)

	# Clear pending interrupts
	li $t0, 0xBF881034 # IFS0CLR
	li $t1, 0x1C000000
	sw $t1, 0($t0)

	# Clear interrupt priority
	li $t0, 0xBF8810F4 # IPC6CLR
	li $t1, 0x1F
	sw $t1, 0($t0)

	# Set the baud rate to 9600
	addi $t0, $t3, 0x48 # UXBRGSET
	li $t1, 259 # Assuming 40 MHz peripheral clock
	sw $t1, 0($t0)

	# Set the status register
	addi $t0, $t3, 0x18 # UXSTASET
	li $t1, 0x1400 # TX and RX enabled
	sw $t1, 0($t0)

	# Set the interrupt priority
	li $t0, 0xBF8810F8 # IPC6SET
	li $t1, 0x10
	sw $t1, 0($t0)

	# Enable TX, RX, and error interrupts (unimplemented)
	li $t0, 0xBF881068 # IEC0SET
	li $t1, 0x1C000000
	#sw $t1, 0($t0)

	# Set the mode register
	addi $t0, $t3, 0x8 # # UXMODESET
	li $t1, 0x8040 # 8 N 1, enable UART, enable loopback
	sw $t1, 0($t0)

	# Init the next port
	addi $t5, $t5, 0x01
	j uart_setup_loop

uart_setup_done:
	jr $ra


# void krnl_uart_write(port, char)
hal_uart_write:
	# Load the UART base for this port
	la $t0, hal_uart_base
	sll $a0, $a0, 2
	add $t0, $a0, $t0
	lw $t1, 0($t0)

uartwritewait:
	# Read the UXSTA register to get the UART status
	addi $t2, $t1, 0x10
	lw $t0, 0($t2)
	andi $t0, $t0, 0x200 # UTXBF bit
	beq $t0, $zero, uartwriteready
	j uartwritewait

uartwriteready:
	# Write the character to the TX register
	addi $t0, $t1, 0x20
	sw $a1, 0($t0)

	jr $ra

# char krnl_uart_read(int port)
hal_uart_read:
	# Load the UART base for this port
	la $t0, hal_uart_base
	sll $a0, $a0, 2
	add $t0, $a0, $t0
	lw $t1, 0($t0)

uartreadwait:
	# Read the UXSTA register to get the UART status
	addi $t2, $t1, 0x10
	lw $t0, 0($t2)
	andi $t0, $t0, 0x1 # RXDA bit
	bne $t0, $zero, uartreadready
	j uartreadwait

uartreadready:
	# Load a character from the RX register
	addi $t0, $t1, 0x30
	lw $v0, 0($t0)

	jr $ra

# void hal_xmips_blink_r()
hal_xmips_blink_r:
	addi $s7, $ra, 0x0
	li $a0, 12
    jal decodebit
	addi $a0, $v0, 0x0
	jal setgbit

	jal waitforblinky

	li $a0, 12
    jal decodebit
	addi $a0, $v0, 0x0
	jal cleargbit
	jr $s7

# void hal_xmips_blink_g()
hal_xmips_blink_g:
	addi $s7, $ra, 0x0
	li $a0, 13
    jal decodebit
	addi $a0, $v0, 0x0
	jal setgbit

	jal waitforblinky

	li $a0, 13
    jal decodebit
	addi $a0, $v0, 0x0
	jal cleargbit
	jr $s7

# void hal_xmips_blink_b()
hal_xmips_blink_b:
	addi $s7, $ra, 0x0
	li $a0, 14
    jal decodebit
	addi $a0, $v0, 0x0
	jal setgbit

	jal waitforblinky

	li $a0, 14
    jal decodebit
	addi $a0, $v0, 0x0
	jal cleargbit
	jr $s7