# Export a C symbol according to Linux and OSX mangling convention.

.macro Export symb
    .globl \symb
    .globl _\symb #OS X symbol
    \symb:
    _\symb:
.endm
