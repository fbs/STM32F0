ENTRY(Reset_Handler)

MEMORY
{
        FLASH (rx)      : ORIGIN = 0x08000000, LENGTH = 64K
        RAM (xrw)       : ORIGIN = 0x20000000, LENGTH = 8K
}

_estack = ORIGIN(RAM)+LENGTH(RAM);

SECTIONS
{
        .isr_vector :
        {
                . = ALIGN(4);
                KEEP(*(.isr_vector))
                . = ALIGN(4);
        } > FLASH

        .text :
        {
                . = ALIGN(4);
                *(.text)
                *(.text.*)
                *(.glue_7)
                *(.glue_7t)
                /* https://sourceware.org/ml/newlib/2005/msg00255.html  */
                KEEP(*(.init))
                KEEP(*(.fini))

                . = ALIGN(4);
                _etext = .; /* End of text section */
        } > FLASH

        .rodata :
        {
                . = ALIGN(4);
                *(.rodata)
                *(.rodata*)
                . = ALIGN(4);
        }

        _sidata = LOADADDR(.data);

        .data :
        {
                . = ALIGN(4);
               _sdata = .;     /* Start of data */
               *(.data)
               . = ALIGN(4);
               *(.data*)
               . = ALIGN(4);
               *(.ramtext)
               . = ALIGN(4);

               _edata = .;      /* End of data */
        } > RAM AT > FLASH

        .bss :
        {
                . = ALIGN(4);
                _sbss = .;      /* Start of bss */
                _bss = .;
                *(.bss)
                . = ALIGN(4);
                *(.bss*)
                . = ALIGN(4);
                *(COMMON)
                . = ALIGN(4);

                _ebss = .;      /* End of bss */
        } > RAM

    /DISCARD/ :
    {
     libc.a ( * )
     libm.a ( * )
     libgcc.a ( * )
     }

    /* Stabs debugging sections. */
    .stab 0 : { *(.stab) }
    .stabstr 0 : { *(.stabstr) }
    .stab.excl 0 : { *(.stab.excl) }
    .stab.exclstr 0 : { *(.stab.exclstr) }
    .stab.index 0 : { *(.stab.index) }
    .stab.indexstr 0 : { *(.stab.indexstr) }
    .comment 0 : { *(.comment) }
    /* DWARF debug sections.
       Symbols in the DWARF debugging sections are relative to the beginning
       of the section so we begin them at 0. */
    /* DWARF 1 */
    .debug 0 : { *(.debug) }
    .line 0 : { *(.line) }
    /* GNU DWARF 1 extensions */
    .debug_srcinfo 0 : { *(.debug_srcinfo) }
    .debug_sfnames 0 : { *(.debug_sfnames) }
    /* DWARF 1.1 and DWARF 2 */
    .debug_aranges 0 : { *(.debug_aranges) }
    .debug_pubnames 0 : { *(.debug_pubnames) }
    /* DWARF 2 */
    .debug_info 0 : { *(.debug_info .gnu.linkonce.wi.*) }
    .debug_abbrev 0 : { *(.debug_abbrev) }
    .debug_line 0 : { *(.debug_line) }
    .debug_frame 0 : { *(.debug_frame) }
    .debug_str 0 : { *(.debug_str) }
    .debug_loc 0 : { *(.debug_loc) }
    .debug_macinfo 0 : { *(.debug_macinfo) }
    /* SGI/MIPS DWARF 2 extensions */
    .debug_weaknames 0 : { *(.debug_weaknames) }
    .debug_funcnames 0 : { *(.debug_funcnames) }
    .debug_typenames 0 : { *(.debug_typenames) }
    .debug_varnames 0 : { *(.debug_varnames) }

}
