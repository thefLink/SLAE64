# Polymorphic version of a flush iptables shellcode

Original shellcode:
```
http://shell-storm.org/shellcode/files/shellcode-683.php
```

The original shellcode is 49 bytes in size and my polymorphic version is 59 bytes in size.

## Changes
1. Use of cdq to null out rdx
2. The original source code uses ```shr``` to deobfuscate strings at runtime. I used ```neg``` to deobfuscate.
