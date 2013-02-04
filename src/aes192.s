#
# AES 192
# Keys are set in registers xmm1 to xmm13.
#
# Blocks are processed in xmm0.
#

.include "macros.s"


#TODO(bps) Factor once clang integrated asm macro support is fixed.
# clang replaces $0 during macro expansion
#.macro key_expand_192
#    pshufd              $0x55, %xmm0, %xmm0
#    movdqa              %xmm1, %xmm15
#    pslldq              $0x04, %xmm15
#    pxor                %xmm15, %xmm1
#    pslldq              $0x04, %xmm15
#    pxor                %xmm15, %xmm1
#    pslldq              $0x04, %xmm15
#    pxor                %xmm15, %xmm1
#    pxor                %xmm0, %xmm1
#    pshufd              $0xff, %xmm1, %xmm0
#    movdqa              %xmm14, %xmm15
#    pslldq              $0x04, %xmm15
#    pxor                %xmm15, %xmm14
#    pxor                %xmm0, %xmm14
#.endm

.macro expand_192_1     dst1, dst2
    pshufd              $0x55, %xmm0, %xmm0
    movdqa              %xmm1, %xmm15
    pslldq              $0x04, %xmm15
    pxor                %xmm15, %xmm1
    pslldq              $0x04, %xmm15
    pxor                %xmm15, %xmm1
    pslldq              $0x04, %xmm15
    pxor                %xmm15, %xmm1
    pxor                %xmm0, %xmm1
    pshufd              $0xff, %xmm1, %xmm0
    movdqa              %xmm14, %xmm15
    pslldq              $0x04, %xmm15
    pxor                %xmm15, %xmm14
    pxor                %xmm0, %xmm14
# move values to destination
    movlhps             %xmm1, \dst1
    movhlps             %xmm1, \dst2
    movlhps             %xmm14, \dst2
.endm

.macro expand_192_2     dst1, dst2
    pshufd              $0x55, %xmm0, %xmm0
    movdqa              %xmm1, %xmm15
    pslldq              $0x04, %xmm15
    pxor                %xmm15, %xmm1
    pslldq              $0x04, %xmm15
    pxor                %xmm15, %xmm1
    pslldq              $0x04, %xmm15
    pxor                %xmm15, %xmm1
    pxor                %xmm0, %xmm1
    pshufd              $0xff, %xmm1, %xmm0
    movdqa              %xmm14, %xmm15
    pslldq              $0x04, %xmm15
    pxor                %xmm15, %xmm14
    pxor                %xmm0, %xmm14
# move values to destination
    movdqa              %xmm1, \dst1
    movq                %xmm14, \dst2
.endm

.macro expand_192_last  dst1
    pshufd              $0x55, %xmm0, %xmm0
    movdqa              %xmm1, %xmm15
    pslldq              $0x04, %xmm15
    pxor                %xmm15, %xmm1
    pslldq              $0x04, %xmm15
    pxor                %xmm15, %xmm1
    pslldq              $0x04, %xmm15
    pxor                %xmm15, %xmm1
    pxor                %xmm0, %xmm1
    pshufd              $0xff, %xmm1, %xmm0
    movdqa              %xmm14, %xmm15
    pslldq              $0x04, %xmm15
    pxor                %xmm15, %xmm14
    pxor                %xmm0, %xmm14
# move values to destination
    movdqa              %xmm1, \dst1
.endm

Export aes192_set_encrypt_keys
set_encrypt_keys:
    movdqa              (%rdi), %xmm1
    movq                0x10(%rdi), %xmm2
    movdqa              %xmm2, %xmm14
    aeskeygenassist     $0x01, %xmm14, %xmm0
    expand_192_1        %xmm2, %xmm3
    aeskeygenassist     $0x02, %xmm14, %xmm0
    expand_192_2        %xmm4, %xmm5
    aeskeygenassist     $0x04, %xmm14, %xmm0
    expand_192_1        %xmm5, %xmm6
    aeskeygenassist     $0x08, %xmm14, %xmm0
    expand_192_2        %xmm7, %xmm8
    aeskeygenassist     $0x10, %xmm14, %xmm0
    expand_192_1        %xmm8, %xmm9
    aeskeygenassist     $0x20, %xmm14, %xmm0
    expand_192_2        %xmm10, %xmm11
    aeskeygenassist     $0x40, %xmm14, %xmm0
    expand_192_1        %xmm11, %xmm12
    aeskeygenassist     $0x80, %xmm14, %xmm0
    expand_192_last     %xmm13
    movdqa              (%rdi), %xmm1
    ret

Export aes192_set_decrypt_keys
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
    ret

Export aes192_encrypt_block
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
    aesenclast          %xmm13, %xmm0
    movdqa              %xmm0, (%rdi)
    ret

Export aes192_decrypt_block
    movdqa              (%rdi), %xmm0
    pxor                %xmm13, %xmm0
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
