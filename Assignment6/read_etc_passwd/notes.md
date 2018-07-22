# Polymorphic version of Mr. Un1k0d3rs 'read /etc/passwd/' shellcode

Orig source:
```
http://shell-storm.org/shellcode/files/shellcode-878.php
```

My polymorphic version of the shellcode reduces the size by 7 bytes and keeps the same functionality as the original code.

In order to do so I made use of smaller instructions such as ```cdq``` or ```push ; pop``` instead of ```mov```.
I also optimized the use of return values of syscalls and reused empty registers to avoid xoring them again.
