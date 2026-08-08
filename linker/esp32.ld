ENTRY(_start)

MEMORY
{
    FLASH (rx)  : ORIGIN = 0x400D0020, LENGTH = 0x330000 - 0x20
    DRAM  (rwx) : ORIGIN = 0x3FFB0000, LENGTH = 0x2C200
}

SECTIONS
{
    .literal :
    {
        . = ALIGN(4);
        *(.literal)
        . = ALIGN(4);
    } > FLASH

    .text :
    {
        . = ALIGN(4);
        *(.text)
        *(.text.*)
        . = ALIGN(4);
    } > FLASH

    .rodata :
    {
        . = ALIGN(4);
        *(.rodata)
        *(.rodata.*)
        . = ALIGN(4);
    } > FLASH

    .data :
    {
        . = ALIGN(4);
        _sdata = .;

        *(.data)
        *(.data.*)

        . = ALIGN(4);
        _edata = .;
    } > DRAM AT > FLASH

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