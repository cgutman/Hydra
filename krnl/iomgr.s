.globl krnl_iomgr_init
.globl krnl_io_write_int
.globl krnl_io_write_float
.globl krnl_io_write_double
.globl krnl_io_write_string
.globl krnl_io_write_char
.globl krnl_io_read_int
.globl krnl_io_read_float
.globl krnl_io_read_double
.globl krnl_io_read_string
.globl krnl_io_read_char

.text
# krnl_iomgr_init()
krnl_iomgr_init:
	jr $ra

# krnl_io_write_int(int)
krnl_io_write_int:
	jr $ra

# krnl_io_write_float(float)
krnl_io_write_float:
	jr $ra

# krnl_io_write_double(double)
krnl_io_write_double:
	jr $ra

# krnl_io_write_string(char*)
krnl_io_write_string:
	addi $a1, $a0, 0x0
	li $a0, 2 # UART 2
	j krnl_serial_write_string

# krnl_io_write_char(char)
krnl_io_write_char:
	addi $a1, $a0, 0x0
	li $a0, 2 # UART 2
	j krnl_serial_write_char

# int krnl_io_read_int()
krnl_io_read_int:
	jr $ra

# float krnl_io_read_float()
krnl_io_read_float:
	jr $ra

# double krnl_io_read_double()
krnl_io_read_double:
	jr $ra

# char* krnl_io_read_string()
krnl_io_read_string:
	li $a0, 2 # UART 2
	#j krnl_serial_read_string
	jr $ra

# char krnl_io_read_char()
krnl_io_read_char:
	li $a0, 2 # UART 2
	j krnl_serial_read_char
