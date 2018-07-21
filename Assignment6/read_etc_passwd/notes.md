# Polymorphic version of Mr. Un1k0d3rs 'read /etc/passwd/' shellcode

Orig source:
```
http://shell-storm.org/shellcode/files/shellcode-878.php
```

## Changes

1. 
    The original shellcode creates a null byte to end the string '/etc/passwdA' by xoring the last A with A. I replaced this by xoring with a B.

2. 
    
    Replaced ```xor rsi, rsi``` with ```mov rsi, rax```. This is the same because rax is still zero due to the ```xor rax, rax``` instruction above.

3. 
    Original source code uses ```xor rdx, rdx``` to put a 0 into rdx. I use ```cdq``` which is possible as rax equals zero. This does also save me 2 bytes as ```cdq``` is a one byte instruction.

4. 
    
    Mr. Un1k0d3r uses ```add dil, 1```. I replaced this by ```inc rdi``` which saves one byte.

## Outcome
    
    The functionality of the source code stays the same, but it has a different fingerprint and is 3 bytes smaller then the original version.
