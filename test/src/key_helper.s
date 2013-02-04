#
# FOR TESTS ONLY
#
.include "macros.s"

Export      aes128_get_keys
	movdqa	%xmm1,  0x00(%rdi)
	movdqa	%xmm2,  0x10(%rdi)
	movdqa	%xmm3,  0x20(%rdi)
	movdqa	%xmm4,  0x30(%rdi)
	movdqa	%xmm5,  0x40(%rdi)
	movdqa	%xmm6,  0x50(%rdi)
	movdqa	%xmm7,  0x60(%rdi)
	movdqa	%xmm8,  0x70(%rdi)
	movdqa	%xmm9,  0x80(%rdi)
	movdqa	%xmm10, 0x90(%rdi)
	movdqa	%xmm11, 0xa0(%rdi)
    ret

Export      aes192_get_keys
	movdqa	%xmm1,  0x00(%rdi)
	movdqa	%xmm2,  0x10(%rdi)
	movdqa	%xmm3,  0x20(%rdi)
	movdqa	%xmm4,  0x30(%rdi)
	movdqa	%xmm5,  0x40(%rdi)
	movdqa	%xmm6,  0x50(%rdi)
	movdqa	%xmm7,  0x60(%rdi)
	movdqa	%xmm8,  0x70(%rdi)
	movdqa	%xmm9,  0x80(%rdi)
	movdqa	%xmm10, 0x90(%rdi)
	movdqa	%xmm11, 0xa0(%rdi)
	movdqa	%xmm12, 0xb0(%rdi)
	movdqa	%xmm13, 0xc0(%rdi)
    ret

Export      aes256_get_keys
	movdqa	%xmm1,  0x00(%rdi)
	movdqa	%xmm2,  0x10(%rdi)
	movdqa	%xmm3,  0x20(%rdi)
	movdqa	%xmm4,  0x30(%rdi)
	movdqa	%xmm5,  0x40(%rdi)
	movdqa	%xmm6,  0x50(%rdi)
	movdqa	%xmm7,  0x60(%rdi)
	movdqa	%xmm8,  0x70(%rdi)
	movdqa	%xmm9,  0x80(%rdi)
	movdqa	%xmm10, 0x90(%rdi)
	movdqa	%xmm11, 0xa0(%rdi)
	movdqa	%xmm12, 0xb0(%rdi)
	movdqa	%xmm13, 0xc0(%rdi)
	movdqa	%xmm14, 0xd0(%rdi)
	movdqa	%xmm15, 0xe0(%rdi)
    ret

Export      aes_set_keys
	movdqa	0x00(%rdi), %xmm1
	movdqa	0x10(%rdi), %xmm2
	movdqa	0x20(%rdi), %xmm3
	movdqa	0x30(%rdi), %xmm4
	movdqa	0x40(%rdi), %xmm5
	movdqa	0x50(%rdi), %xmm6
	movdqa	0x60(%rdi), %xmm7
	movdqa	0x70(%rdi), %xmm8
	movdqa	0x80(%rdi), %xmm9
	movdqa	0x90(%rdi), %xmm10
	movdqa	0xa0(%rdi), %xmm11
	movdqa	0xb0(%rdi), %xmm12
	movdqa	0xc0(%rdi), %xmm13
	movdqa	0xd0(%rdi), %xmm14
	movdqa	0xe0(%rdi), %xmm15
    ret
