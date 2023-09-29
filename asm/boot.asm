[org 0x7c00]
BITS 16
%define STACK_ADDRESS 0x7c00
%define VIDEO_MEM 0xa0000

setup_stack:
	mov bp, STACK_ADDRESS
	mov sp, bp

preload:
	; "Load second sector of disk and run it"

	mov bx, 0x7e00
	mov dx, 0x0180
	call disk_read

pre:
	nop
	mov ah, 0x00
	mov al, 0x0d
	int 0x10


	.A20:
		mov bx, A20
		call print
		in al, 0xee
		call check_a20
		sti
		mov dx, ax
		cmp dx, 0x1
		jne .disabled

	.enabled:
		mov bx, OK
		call print
		jmp .main

	.disabled:
		mov bx, BAD
		call print

	.main:
		mov bx, string
		call print
		jmp halt

check_a20:
    pushf
    push ds
    push es
    push di
    push si
 
    cli
 
    xor ax, ax ; ax = 0
    mov es, ax
 
    not ax ; ax = 0xFFFF
    mov ds, ax
 
    mov di, 0x0500
    mov si, 0x0510
 
    mov al, byte [es:di]
    push ax
 
    mov al, byte [ds:si]
    push ax
 
    mov byte [es:di], 0x00
    mov byte [ds:si], 0xFF
 
    cmp byte [es:di], 0xFF
 
    pop ax
    mov byte [ds:si], al
 
    pop ax
    mov byte [es:di], al
 
    mov ax, 0
    je check_a20__exit
 
    mov ax, 1
 
check_a20__exit:
    pop si
    pop di
    pop es
    pop ds
    popf
 
    ret

halt:
	jmp $

%include "macros/print.mac"
%include "macros/disk.mac"

times 510-($-$$) db 0
dw 0xaa55


newline:
	db "\n", 0
string:
	db "Hello World\n", 0

A20:
	db "Checking A20 line...", 0
OK:
	db "OK\n", 0
BAD:
	db "BAD\n", 0

