;
; Print function
; push text to stack then other args to stack
;
print:
    push bp
    mov bp, sp
    pusha

    mov ah, 0x0e
    mov si, [bp+4]

    .loop:
        lodsb
        cmp al, "\"
        je .var_parser
        cmp al, 0
        je .exit
        int 10h
        jmp .loop

    .var_parser:
        lodsb
        cmp al, "n"
        je .print_nl
        cmp al, "x"
        je .print_hex
        jmp .end

        .print_nl:
            push newline
            call print
            pop dx
            jmp .end

        .print_hex:
            mov dx, [bp+6]
            push dx
            call print_hex
            pop dx
            jmp .end

        .end:
            jmp .loop

    .exit:
        popa
        pop bp
        ret

print_hex:
    push bp
    mov bp, sp
    pusha

    times 2 push 0xffff ; make space for hex

    mov dx, [bp+4]
    mov cx, 4


    .l1:
        mov ax, dx
        and ax, 000fh
        add al, 30h
        cmp al, 39h
        jle .end
        add al, 10h
        sub al, 9h

        .end:
            mov bx, sp
            sub cx, 1
            add bx, cx
            add cx, 1
            mov [bx], al
            ror dx, 4
            loop .l1

    mov si, sp
    mov cx, 4
    mov di, hex_buffer+2
    rep movsb

    ; print hex
    push hex_buffer
    call print

    ; clean stack
    times 3 pop dx

    popa
    pop bp
    ret

newline: dw 0x0d0a, 0
hex_buffer db "0x0000", 0
