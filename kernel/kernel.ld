ENTRY(_reset)

MEMORY{
  FLASH(rx) : ORIGIN = 0x08000000, LENGTH = 512K
  SRAM(rwx) : ORIGIN = 0x20010000, LENGTH = 192K
  DTCM(rwx) : ORIGIN = 0x20000000, LENGTH = 64K
}

_estack = ORIGIN(DTCM) + LENGTH(DTCM);

SECTIONS{
  .vectors : { KEEP( *(.vectors) ) } > FLASH
  .text    : { *(.text) }            > FLASH
  .rodata  : { *(.rodata*) }         > FLASH

  .data    : {
    _sdata = .;
    *(.firstdata)
    *(.data* SORT(.data.*))
    _edata = .;
  } > SRAM AT >  FLASH
  _sidata = LOADADDR(.data);

  .bss     : {
    _sbss = .;
    *(.bss* SORT(.bss.*) COMMON)
    _ebss = .;
  } > SRAM

  . = ALIGN(8);
  _end = .;
}
