# stm32f7 self practice

Linker script
ENTRY() : function ENTRY select the first instruction started position.

	ENTRY(_reset)

MEMORY{} : this command could set the attribute of mem, content should between {}.

	syntax
	MEMORY{
		name[(attr)] : ORIGIN = origin, LENGTH = len
	}

	e.g.
	MEMORY{
		FLASH (rx) : ORIGIN = 0x000000000, LENGTH = 128K
	}

. : means location counter, when a section started counter would set to 0. The following syntax could shift the location counter:

	. = 0x10000 // shift location counter to 0x10000

.text : define a output section named text, content should between {}

	.text{
		KEEP(*(.isr_vector))
		*(.text)
	} >FLASH

KEEP() : when link-time garbage collection is on, you could use KEEPto prevent some section been discarded.

* (.text): means put .text input section ay any file into here, * is a wildcard

 >region : put output section into memory region.



