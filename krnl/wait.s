.globl krnl_wait_cycles

# void krnl_wait_cycles(int cycles)
krnl_wait_cycles:
	# Read the starting time
	mfc0 $t0, $9

	# Offset the parameter to be the real end
	add $a0, $a0, $t0

cyclewaitloop:
		# Read the current time
		mfc0 $t0, $9

		# Check if the wait expired
		blt $t0, $a0, cyclewaitloop

	# Wait complete
	jr $ra
