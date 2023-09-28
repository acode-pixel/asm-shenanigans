print:
	; "print character in AL into the creen"
	; "needs AH to be 0E to function"
	; "takes BX as a pointer to the string"

	pusha

	mov ah, 0x0e

	cmp bx, 0
	je .nostr_error
	
	.loop:
		mov dx, [bx]
		cmp dl, 0
		je .stop
		cmp dl, 0x5c
		je .special_chars
		mov al, dl
		push bx
		mov bx, 0x0007 ; "adds color if set to graphics mode (13h)"
		int 0x10
		pop bx
		inc bx
		jmp .loop

	.nostr_error:
		mov bx, nostring
		jmp print

	.special_chars:
		cmp dh, 0x6e
		je .print_nl
		
		mov al, dl
		int 0x10
		inc bx
		jmp .loop

	.print_nl:
		mov al, 0x0a
		int 0x10
		mov al, 0x0d
		int 0x10
		add bx, 2
		jmp .loop

	.stop:
		popa
		ret

print_hex:
	; "Store hex at DX"
	; "CALLS print to print out hex representation"
	; "Use CX as pointer to which bit is used"

	pusha
	mov cx, 0

	.loop:
		mov ax, dx
		and ax, 0x000f ; "bit mask last bit"
		add al, 0x30
		cmp al, 0x39
		jle .store_bits
		add al, 7 ; "convert to alphabetic"

	.store_bits:
		mov bx, HEX_OUT + 5
		sub bx, cx
		mov [bx], al
		inc cx
		ror dx, 4 ; "shift DX by four bits to the right"
		cmp cx, 4
		jge .print
		jmp .loop

	.print:
		mov bx, HEX_OUT
		call print

	.stop:
		popa
		ret

HEX_OUT:
	db "0x0000", 0

nostring:
	db "\nno string pointer detected", 0
