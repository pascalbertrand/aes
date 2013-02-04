#
# AES 256
#
# Keys are set in registers xmm1 to xmm15.
#
# Block are processed in xmm0.
#

.include "macros.s"

.macro expand_256       dst1, dst2
    pshufd              $0xff, %xmm0, %xmm0
    movdqu              %xmm1, \dst2
    pslldq              $0x04, \dst2
    pxor                \dst2, %xmm1
    pslldq              $0x04, \dst2
    pxor                \dst2, %xmm1
    pslldq              $0x04, \dst2
    pxor                \dst2, %xmm1
    pxor                %xmm0, %xmm1
    movdqu              %xmm1, \dst1
    aeskeygenassist     $0x00, %xmm1, \dst2
    pshufd              $0xaa, \dst2, %xmm0
    movdqu              %xmm2, \dst2
    pslldq              $0x04, \dst2
    pxor                \dst2, %xmm2
    pslldq              $0x04, \dst2
    pxor                \dst2, %xmm2
    pslldq              $0x04, \dst2
    pxor                \dst2, %xmm2
    pxor                %xmm0, %xmm2
    movdqu              %xmm2, \dst2
.endm

.macro expand_256_last  dst1
    pshufd              $0xff, %xmm0, %xmm0
    movdqu              %xmm1, \dst1
    pslldq              $0x04, \dst1
    pxor                \dst1, %xmm1
    pslldq              $0x04, \dst1
    pxor                \dst1, %xmm1
    pslldq              $0x04, \dst1
    pxor                \dst1, %xmm1
    pxor                %xmm0, %xmm1
    movdqu              %xmm1, \dst1
.endm


Export aes256_set_encrypt_keys
set_encrypt_keys:
    movdqa              0x00(%rdi), %xmm1
    movdqa              0x10(%rdi), %xmm2
    aeskeygenassist     $0x01, %xmm2, %xmm0
    expand_256          %xmm3, %xmm4
    aeskeygenassist     $0x02, %xmm2, %xmm0
    expand_256          %xmm5, %xmm6
    aeskeygenassist     $0x04, %xmm2, %xmm0
    expand_256          %xmm7, %xmm8
    aeskeygenassist     $0x08, %xmm2, %xmm0
    expand_256          %xmm9, %xmm10
    aeskeygenassist     $0x10, %xmm2, %xmm0
    expand_256          %xmm11, %xmm12
    aeskeygenassist     $0x20, %xmm2, %xmm0
    expand_256          %xmm13, %xmm14
    aeskeygenassist     $0x40, %xmm2, %xmm0
    expand_256_last     %xmm15
    movdqa              0x10(%rdi), %xmm2
    movdqa              0x00(%rdi), %xmm1
    ret

Export aes256_set_decrypt_keys
    call                set_encrypt_keys
    aesimc              %xmm2, %xmm2
    aesimc              %xmm3, %xmm3
    aesimc              %xmm4, %xmm4
    aesimc              %xmm5, %xmm5
    aesimc              %xmm6, %xmm6
    aesimc              %xmm7, %xmm7
    aesimc              %xmm8, %xmm8
    aesimc              %xmm9, %xmm9
    aesimc              %xmm10, %xmm10
    aesimc              %xmm11, %xmm11
    aesimc              %xmm12, %xmm12
    aesimc              %xmm13, %xmm13
    aesimc              %xmm14, %xmm14
    ret

Export aes256_encrypt_block
    movdqa              (%rdi), %xmm0
    pxor                %xmm1, %xmm0
    aesenc              %xmm2, %xmm0
    aesenc              %xmm3, %xmm0
    aesenc              %xmm4, %xmm0
    aesenc              %xmm5, %xmm0
    aesenc              %xmm6, %xmm0
    aesenc              %xmm7, %xmm0
    aesenc              %xmm8, %xmm0
    aesenc              %xmm9, %xmm0
    aesenc              %xmm10, %xmm0
    aesenc              %xmm11, %xmm0
    aesenc              %xmm12, %xmm0
    aesenc              %xmm13, %xmm0
    aesenc              %xmm14, %xmm0
    aesenclast          %xmm15, %xmm0
    movdqa              %xmm0, (%rdi)
    ret

Export aes256_decrypt_block
    movdqa              (%rdi), %xmm0
    pxor                %xmm15, %xmm0
    aesdec              %xmm14, %xmm0
    aesdec              %xmm13, %xmm0
    aesdec              %xmm12, %xmm0
    aesdec              %xmm11, %xmm0
    aesdec              %xmm10, %xmm0
    aesdec              %xmm9, %xmm0
    aesdec              %xmm8, %xmm0
    aesdec              %xmm7, %xmm0
    aesdec              %xmm6, %xmm0
    aesdec              %xmm5, %xmm0
    aesdec              %xmm4, %xmm0
    aesdec              %xmm3, %xmm0
    aesdec              %xmm2, %xmm0
    aesdeclast          %xmm1, %xmm0
    movdqa              %xmm0, (%rdi)
    ret
