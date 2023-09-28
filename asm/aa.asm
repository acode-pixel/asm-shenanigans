[extern main]
nop
mov ah, 0x0e
mov al, 0x41
int 0x10

call main
jmp $
