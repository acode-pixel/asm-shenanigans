disk_read:
	; "Uses DX register"
	; "push pointer to buffer"
	; "push sectors to read, ebx = cylinder, head, sector number"
	; "NOTE: Overhaul disk function to increase read capacity"

    push bp
    mov bp, sp
	pusha

    mov dx, [bp+4]

	mov ah, 0x02
	mov al, dl ; "sectors to read"

    mov dh, bh ; "which head to start"
	mov cl, bl ; "which sector to start"
	ror ebx, 8
	and ebx, 0x0000ff00
	mov ch, bh ; "which cylinder to start"

	mov dl, 0
	mov bx, [bp+6]

	int 0x13

	jc .read_error
	jmp .stop

	.read_error:
		mov ah, 0x01
		int 0x13
		and ax, 0x00ff

		push ax
		push read_error_text
		call print
		times 2 pop ax

	.stop:
		popa
		pop bp
		ret

read_error_text: db "DISK READ ERROR CODE: \x\n", 0

lba_to_chs:
    push bp
    mov bp, sp
    pusha

	mov bx, [bp+4] ; LBA

	; C = LBA / (HPC * SPT)
	mov ax, 2
	imul ax, 8
	mov cx, ax

    mov dx, 0
	mov ax, bx
	div cx

	push ax
	push C
	call print
	times 2 pop ax

    ; H = (LBA / SPT) mod HPC
    mov dx, 0
    mov ax, bx
    mov cx, 8
    div cx

    mov dx, 0
    mov cx, 2
    div cx

    push dx
    push H
    call print
    times 2 pop ax

    ; S = (LBA mod SPT) + 1
    mov dx, 0
    mov ax, bx
    mov cx, 8
    div cx
    inc dx

    push dx
    push S
    call print
    times 2 pop ax

    popa
    pop bp
    ret
