XTENSA ?= $(HOME)/.platformio/packages/toolchain-xtensa-esp-elf/bin

CC_NATIVE := clang

CC_XTENSA := $(XTENSA)/xtensa-esp32-elf-gcc
AS_XTENSA := $(XTENSA)/xtensa-esp32-elf-as
LD_XTENSA := $(XTENSA)/xtensa-esp32-elf-ld

all:
	@echo "WesterOS"

native:
	@echo "Using $(CC_NATIVE)"
	$(CC_NATIVE) --version

esp32:
	@echo "Using $(CC_XTENSA)"
	$(CC_XTENSA) --version

clean:
	rm -rf build/*