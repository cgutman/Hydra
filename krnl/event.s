.globl krnl_event_init
.globl krnl_event_wait
.globl krnl_event_signal
.globl krnl_event_is_signalled

#
# This event implementation uses mutexes to get the
# wait functionality. As such, mutexes require 8 bytes of memory.
# Events are NOT signalled at creation.
#

# void krnl_event_init(int* event)
krnl_event_init:
	j krnl_mutex_init

# void krnl_event_wait(int* event)
krnl_event_wait:
	j krnl_mutex_acquire

# void krnl_event_signal(int* event)
krnl_event_signal:
	j krnl_mutex_release

# int krnl_event_is_signalled(int* event)
krnl_event_is_signalled:
	j krnl_mutex_is_locked
