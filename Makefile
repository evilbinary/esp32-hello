all: build


qemu: build
	esptool.py --chip esp32 --trace elf2image --output main.bin --version 3 --min-rev 1 --flash_freq 40m --flash_mode dio --flash_size 16MB main.elf

	dd if=main.bin of=main.bin.img bs=1 seek=4k
	truncate -s 4M main.bin.img

	~/dev/qemu-esp32/build/qemu-system-xtensa -M esp32  --trace "*mtd*" -serial stdio -monitor telnet:localhost:1235,server,nowait -drive file=main.bin.img,if=mtd,format=raw -m 4M  #-d cpu_reset -d in_asm,int,mmu


build:
	xtensa-esp32-elf-gcc -mlongcalls -mtext-section-literals -c  main.c -o main.o 
	xtensa-esp32-elf-ld main.o  -Tlinker.ld -o main.elf


flash: build
	esptool.py --chip esp32 --port /dev/cu.wchusbserial1413100 --baud 115200 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 40m --flash_size detect 0x1000 main.bin
