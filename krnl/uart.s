.globl krnl_uart_init
.globl krnl_uart_read
.globl krnl_uart_write

.data

.text
# void krnl_uart_init()
krnl_uart_init:
	# Clear the mode register
	li $t0, 0xBF806004 # U1MODECLR
	li $t1, 0xFFFFFFFF
	sw $t1, 0($t0)

	# Clear the status register
	li $t0, 0xBF806014 # U1STACLR
	li $t1, 0xFFFFFFFF
	sw $t1, 0($t0)

	# Clear the baud register
	li $t0, 0xBF806044 # U1BRGCLR
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
	li $t0, 0xBF806048
	li $t1, 51 # Assuming 80 MHz peripheral clock
	sw $t1, 0($t0)

	# Set the status register
	li $t0, 0xBF806018 # U1STASET
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
	li $t0, 0xBF806008 # U1MODESET
	li $t1, 0x8008 # 8 N 1, enable UART
	sw $t1, 0($t0)

	jr $ra


# void krnl_uart_write(char)
krnl_uart_write:

uartwritewait:
	li $t0, 0xBF806010 # U1STA
	lw $t0, 0($t0)
	andi $t0, $t0, 0x200 # UTXBF bit
	beq $t0, $zero, uartwriteready
	j uartwritewait

uartwriteready:
	# Write the character to the TX register
	li $t0, 0xBF806020
	sw $a0, 0($t0)

	jr $ra

# char krnl_uart_read()
krnl_uart_read:

uartreadwait:
	li $t0, 0xBF806010 # U1STA
	lw $t0, 0($t0)
	andi $t0, $t0, 0x1 # RXDA bit
	bne $t0, $zero, uartreadready
	j uartreadwait

uartreadready:
	# Load a character from the RX register
	li $t0, 0xBF806030
	lw $v0, 0($t0)

	jr $ra
