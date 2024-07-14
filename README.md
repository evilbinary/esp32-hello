# esp32-hello

```bash

[evil]$make qemu
xtensa-esp32-elf-gcc -mlongcalls -mtext-section-literals -c  main.c -o main.o 
main.c:71:6: warning: conflicting types for built-in function 'putchar'; expected 'int(int)' [-Wbuiltin-declaration-mismatch]
   71 | void putchar(char character) {
      |      ^~~~~~~
main.c:3:1: note: 'putchar' is declared in header '<stdio.h>'
    2 | #include <stddef.h>
  +++ |+#include <stdio.h>
    3 | 
main.c: In function 'putchar':
main.c:72:5: warning: implicit declaration of function 'uart_write_char' [-Wimplicit-function-declaration]
   72 |     uart_write_char(character);
      |     ^~~~~~~~~~~~~~~
main.c: At top level:
main.c:86:6: warning: conflicting types for 'uart_write_char'; have 'void(char)'
   86 | void uart_write_char(char c) {
      |      ^~~~~~~~~~~~~~~
main.c:72:5: note: previous implicit declaration of 'uart_write_char' with type 'void(char)'
   72 |     uart_write_char(character);
      |     ^~~~~~~~~~~~~~~
xtensa-esp32-elf-ld main.o  -Tlinker.ld -o main.elf
esptool.py --chip esp32 --trace elf2image --output main.bin --version 3 --min-rev 1 --flash_freq 40m --flash_mode dio --flash_size 16MB main.elf
esptool.py v4.7.0
Creating esp32 image...
Successfully created esp32 image.
dd if=main.bin of=main.bin.img bs=1 seek=4k
256+0 records in
256+0 records out
256 bytes transferred in 0.000953 secs (268570 bytes/sec)
truncate -s 4M main.bin.img
~/dev/qemu-esp32/build/qemu-system-xtensa -M esp32  --trace "*mtd*" -serial stdio -monitor telnet:localhost:1235,server,nowait -drive file=main.bin.img,if=mtd,format=raw -m 4M  #-d cpu_reset -d in_asm,int,mmu
==29018==WARNING: ASan is ignoring requested __asan_handle_no_return: stack top: 0x7ffee8e50000; bottom 0x00011179d000; size: 0x7ffdd76b3000 (140728217579520)
False positive error reports may follow
For details see https://github.com/google/sanitizers/issues/189
Adding SPI flash device
ets Jul 29 2019 12:21:46

rst:0x1 (POWERON_RESET),boot:0x12 (SPI_FAST_FLASH_BOOT)
configsip: 0, SPIWP:0xee
clk_drv:0x00,q_drv:0x00,d_drv:0x00,cs0_drv:0x00,hd_drv:0x00,wp_drv:0x00
mode:DIO, clock div:2
load:0x40080000,len:188
entry 0x40080098
abc

```