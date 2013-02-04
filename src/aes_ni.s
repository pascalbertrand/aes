#
# AES-NI
#
# Check if the processor supports AES instructions.
#

.include "macros.s"

.set	aes_ni_bit, 1 << 24

Export aes_ni_present
	movl	$1, %eax
    cpuid
    andl	$aes_ni_bit, %ecx
    movl	%ecx, %eax
	ret
