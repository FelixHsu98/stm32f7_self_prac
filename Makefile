K = kernel
C_SOURCE = \
	$K/startup.o \
	$K/main.o \
	$K/uart.o
S_SOURCE = \
	$K/swtch.o \
	$K/syscall1.o

CROSS_PLATFORM ?= arm-none-eabi-

CC := $(CROSS_PLATFORM)gcc
AS := $(CROSS_PLATFORM)as
LD := $(CROSS_PLATFORM)ld
OBJCOPY := $(CROSS_PLATFORM)objcopy
OBJDUMP := $(CROSS_PLATFORM)objdump
CFLAGS = -Wall -Wextra -Werror -fno-common -ffreestanding \
	 -mfloat-abi=hard -mfpu=fpv5-sp-d16 \
	 -ggdb -O0 -march=armv7e-m -mcpu=cortex-m7 -mthumb
LDFLAGS ?=  -z max-page-size=4096 -T $(K)/kernel.ld

CFG ?= ~/openocd/tcl/
ICFG := $(CFG)interface/stlink.cfg
BCFG := $(CFG)/board/stm32f7discovery.cfg

flash: firmware.bin
	echo "step4"
	#st-flash --reset write $< 0x8000000
	openocd -f $(ICFG) -f $(BCFG) -c "program $< 0x08000000 reset exit"

firmware.bin: firmware.elf
	echo "step3"
	$(OBJCOPY) -O binary $< $@

firmware.elf: $(C_SOURCE) $(S_SOURCE) $K/kernel.ld
	echo "step2"
	$(LD) $(LDFLAGS) $(C_SOURCE) $(S_SOURCE) -o $@
	$(OBJDUMP) -S $@ > $K/kernel.asm

$(S_SOURCE): $K/%.o: $K/%.S
$(S_SOURCE):
	$(CC) $(CFLAGS) -c $< -o $@

$K/%.o: $K/%.c
	echo "step1"
	$(CC) $(CFLAGS) -c $< -o $@ 

.PHONY: flash-gdb
flash-gdb:
	openocd -f $(ICFG) -f $(BCFG)

clean:
	rm -f $K/*.o $K/*.asm *.elf *.bin
