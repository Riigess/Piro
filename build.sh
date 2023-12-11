#!/bin/bash
if [[ $1 == "build" ]]; then
    arm-none-eabi-gcc -mcpu=cortex-a7 -ffreestanding -c src/boot.S -o build/boot.o
    arm-none-eabi-gcc -mcpu=cortex-a7 -ffreestanding -std=gnu99 -c src/kernel.c -o build/kernel.o -O2 -Wall -Wextra
    arm-none-eabi-gcc -T src/linker.ld -o build/myos.elf -ffreestanding -O2 -nostdlib build/boot.o build/kernel.o
    echo "Built OS files."
fi

if [[ $1 == "run" ]]; then
    echo "Running qemu for myos.elf..."
    qemu-system-arm -m 1024 -M raspi2b -serial mon:stdio -kernel build/myos.elf
fi
