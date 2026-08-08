ENTRY(_start)

MEMORY
{
    IRAM (rwx) : ORIGIN = 0x40078000, LENGTH = 0x8000
    DRAM (rw)  : ORIGIN = 0x3FFF0000, LENGTH = 0x10000
}

SECTIONS
{
    .literal :
    {
        . = ALIGN(4);
        *(.literal)
        . = ALIGN(4);
    } > IRAM

    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text.*)
        . = ALIGN(4);
    } > IRAM

    .rodata :
    {
        . = ALIGN(4);
        *(.rodata)
        *(.rodata.*)
        . = ALIGN(4);
    } > DRAM

    .data :
    {
        . = ALIGN(4);
        _sdata = .;
        *(.data)
        *(.data.*)
        . = ALIGN(4);
        _edata = .;
    } > DRAM

    .bss :
    {
        . = ALIGN(4);
        _sbss = .;
        *(.bss)
        *(.bss.*)
        *(COMMON)
        . = ALIGN(4);
        _ebss = .;
    } > DRAM

    _sidata = LOADADDR(.data);
    _stack_top = ORIGIN(DRAM) + LENGTH(DRAM);
}