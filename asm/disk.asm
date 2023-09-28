disk_read:
	; "Uses DX register"
	; "DH = sectors to read, DL = drive number"
	; "store contents at buffer [ES:BX]"

	pusha

	mov ah, 0x02
	mov al, dh ; "sectors to read"
	mov ch, 0 ; "which track to start"
	mov cl, 2 ; "which sector to start"
	mov dh, 0 ; "which head to start"

	int 0x13
	
	jc .read_error
	jmp .stop

	.read_error:
		mov ah, 0x01
		int 0x13
		and ax, 0x00ff
		mov dx, ax
		call print_hex

	.stop:
		popa
		ret
