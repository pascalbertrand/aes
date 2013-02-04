#
# AES 128
#
# Keys are set in registers xmm1 to xmm11.
#
# Block are processed in xmm0.
#

.include "macros.s"

.macro expand_128       dst
    pshufd              $0xff, %xmm12, %xmm12
    movdqa              %xmm0, %xmm13
    pslldq              $0x04, %xmm13
    pxor                %xmm13, %xmm0
    movdqa              %xmm0, %xmm13
    pslldq              $0x04, %xmm13
    pxor                %xmm13, %xmm0
    movdqa              %xmm0, %xmm13
    pslldq              $0x04, %xmm13
    pxor                %xmm13, %xmm0
    pxor                %xmm12, %xmm0
    movdqa              %xmm0, \dst
.endm

Export aes128_set_encrypt_keys
set_encrypt_keys:
    movdqa              (%rdi), %xmm0
    movdqa              %xmm0, %xmm1
    aeskeygenassist     $0x01, %xmm0, %xmm12
    expand_128          %xmm2
    aeskeygenassist     $0x02, %xmm0, %xmm12
    expand_128          %xmm3
    aeskeygenassist     $0x04, %xmm0, %xmm12
    expand_128          %xmm4
    aeskeygenassist     $0x08, %xmm0, %xmm12
    expand_128          %xmm5
    aeskeygenassist     $0x10, %xmm0, %xmm12
    expand_128          %xmm6
    aeskeygenassist     $0x20, %xmm0, %xmm12
    expand_128          %xmm7
    aeskeygenassist     $0x40, %xmm0, %xmm12
    expand_128          %xmm8
    aeskeygenassist     $0x80, %xmm0, %xmm12
    expand_128          %xmm9
    aeskeygenassist     $0x1b, %xmm0, %xmm12
    expand_128          %xmm10
    aeskeygenassist     $0x36, %xmm0, %xmm12
    expand_128          %xmm11
    ret

Export aes128_set_decrypt_keys
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
    ret

Export aes128_encrypt_block
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
    aesenclast          %xmm11, %xmm0
    movdqa              %xmm0, (%rdi)
    ret

Export aes128_decrypt_block
    movdqa              (%rdi), %xmm0
    pxor                %xmm11, %xmm0
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
