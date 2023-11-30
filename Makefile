CROSS_PLATFORM ?= arm-none-eabi-

CC := $(CROSS_PLATFORM)gcc
LD := $(CROSS_PLATFORM)ld
OBJCOPY := $(CROSS_PLATFORM)objcopy
OBJDUMP := $(CROSS_PLATFORM)objdump
CFLAGS ?= -Wall -Wextra -Werror -fno-common \
	 -ggdb -O0 -mcpu=cortex-m7
LDFLAGS ?=  -z max-page-size=4096 -T kernel.ld

SOURCE = main.o

flash: firmware.bin
	echo "step4"
	st-flash --reset write $< 0x8000000

firmware.bin: firmware.elf
	echo "step3"
	$(OBJCOPY) -O binary $< $@

firmware.elf: $(SOURCE)
	echo "step2"
	$(LD) $(LDFLAGS) $^ -o $@
	$(OBJDUMP) -S $@ > kernel.asm

%.o: %.c
	echo "step1"
	$(CC) $(CFLAGS) -c $< -o $@  

clean:
	rm -f *.o *.asm *.elf *.bin
