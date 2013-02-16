.globl krnl_fubar

#
# This file implements a little function called krnl_fubar()
# that kernel code calls when shit goes south. It is implemented
# as a jump to itself. This means all current state is kept and no
# registers are touched.
#

.data

.text
# void krnl_fubar()
krnl_fubar:
	j krnl_fubar
