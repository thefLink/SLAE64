# Polymorphic version of a 33 byte execve shellcode

Original version:
```
http://shell-storm.org/shellcode/files/shellcode-76.php
```

This post describes a polymorphic version of a 33 byte execve shellcode.
My polymorphic version is 31 bytes in size and thus 2 bytes shorter then its original version.

## Changes

1. I used ```cdq``` in order to zero out rdx.
2. The original version uses ```shr``` to obfuscate the /bin/sh string. I changed this obfuscation by moving hex(/bin/sh) - 0x13377331 in rbx and then adding 0x13377331 again to deobfuscate at runtime.
