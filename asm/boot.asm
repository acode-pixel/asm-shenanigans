[org 0x7c00]
BITS 16
%define STACK_ADDRESS 0x7c00

jmp setup_stack
times 8 nop

dw 0x0200 ; Bytes per logical sector
db 0x08 ; Logical sectors per track
dw 0x0001 ; Count of reserved sectors
db 0x02 ; Count of File Allocation Tables
dw 0x0010 ; Max number of FAT12/16 root directory entries
db 0x08 ; Total logical sectors
db 0xfe ; Media Descriptor
dw 0x0001 ; sectors per FAT


setup_stack:
	mov bp, STACK_ADDRESS
	mov sp, bp

preload:
    push 0x0000
    call lba_to_chs

halt:
    push stop_string
    call print
    hlt
	jmp $

%include "print.asm"
%include "disk.asm"

stop_string:
	db "STOPPING EXECUTION\n", 0
C:
    db "Cylinder: \x\n", 0
H:
    db "Head: \x\n", 0
S:
    db "Sector: \x\n", 0

times 510-($-$$) db 0
dw 0xaa55
