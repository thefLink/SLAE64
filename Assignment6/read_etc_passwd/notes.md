# Polymorphic version of Mr. Un1k0d3rs 'read /etc/passwd/' shellcode

Orig source:
```
http://shell-storm.org/shellcode/files/shellcode-878.php
```

My polymorphic version of the shellcode reduces the size by 7 bytes and keeps the same functionality as the original code.

## Changes
1. Usage of smaller instructions such as ```cdq``` to zero or rdx or ```push; pop``` instead of ```mov```
2. Optimized usage of syscall's return values
3. Reuse of nulled registers to avoid xoring others
