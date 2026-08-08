#!/usr/bin/env bash
set -e

export XTENSA=~/.platformio/packages/toolchain-xtensa-esp-elf/bin
export PATH=$XTENSA:$PATH

BUILD_DIR=build

CC=xtensa-esp32-elf-gcc
READELF=xtensa-esp32-elf-readelf
OBJDUMP=xtensa-esp32-elf-objdump

CFLAGS="-ffreestanding -fno-builtin -Wall -Wextra -Os -Iinclude"
LDFLAGS="-nostdlib -T linker/esp32.ld"

echo "==> Cleaning..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

echo "==> Assembling startup..."
$CC -c boot/startup.S -o "$BUILD_DIR/startup.o"

echo "==> Compiling kernel..."
for file in kernel/*.c; do
    obj="$BUILD_DIR/$(basename "${file%.c}.o")"
    echo "  $(basename "$file")"
    $CC $CFLAGS -c "$file" -o "$obj"
done

echo "==> Compiling drivers..."
for file in drivers/*.c; do
    obj="$BUILD_DIR/$(basename "${file%.c}.o")"
    echo "  $(basename "$file")"
    $CC $CFLAGS -c "$file" -o "$obj"
done

echo "==> Linking..."
$CC $LDFLAGS "$BUILD_DIR"/*.o -o "$BUILD_DIR/westeros.elf"

echo "==> ELF Program Headers"
$READELF -l "$BUILD_DIR/westeros.elf"

echo "==> Creating ESP32 Image..."
esptool --chip esp32 elf2image --flash-mode dio --flash-freq 40m --flash-size 4MB "$BUILD_DIR/westeros.elf"

echo "==> Image Info"
esptool image-info "$BUILD_DIR/westeros.bin"

echo
echo "======================================="
echo " Build Successful"
echo "======================================="
echo "ELF : $BUILD_DIR/westeros.elf"
echo "BIN : $BUILD_DIR/westeros.bin"
echo
echo "Flash:"
echo "esptool --chip esp32 --port /dev/cu.usbserial-0001 --baud 460800 \\"
echo "    write-flash 0x1000 $BUILD_DIR/westeros.bin"