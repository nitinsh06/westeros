.section .text
.global _start

.extern kernel_main
.extern _stack_top
.extern _sidata
.extern _sdata
.extern _edata
.extern _sbss
.extern _ebss

_start:
    movi    a1, _stack_top

    # copy .data register address saving
    movi    a2, _sidata  # address register
    movi    a3, _sdata   # address register
    movi    a4, _edata   # address register


copy_data:
    bgeu    a3, a4, copy_done

    l32i    a5, a2, 0
    s32i    a5, a3, 0

    addi   a2, a2, 4
    addi   a3, a3, 4

    j      copy_data

copy_done:

    # copy .bss register address saving
    movi    a2, _sbss  # address register
    movi    a3, _ebss  # address register
    movi    a4, 0      # value register


zero_bss:
    bgeu    a2, a3, bss_done

    s32i    a4, a2, 0
    addi    a2, a2, 4  # similar to say a2++, advance pointer by one 32-bit word (4 bytes)

    j       zero_bss

bss_done:
    call4   kernel_main

1:
    j   1b

