# Exec Shellcode
The first payload I have choosen to analyse is the 'exec' payload which allows the execution of a single command.

I created the shellcode using msfvenom like this:
```
msfvenom -p linux/x64/exec CMD=whoami -f c
```

As you can see by the CMD paramaeter I create a shellcode that does nothing else but executing the 'whoami' command.

## Testmodule
Next I placed the resulting char array in a C program:

```
    unsigned char shellcode[] =
    "\x6a\x3b\x58\x99\x48\xbb\x2f\x62\x69\x6e\x2f\x73\x68\x00\x53"
    "\x48\x89\xe7\x68\x2d\x63\x00\x00\x48\x89\xe6\x52\xe8\x07\x00"
    "\x00\x00\x77\x68\x6f\x61\x6d\x69\x00\x56\x57\x48\x89\xe6\x0f"
    "\x05";

    (*(void(*)()) shellcode)();
```

and compiled as follows:

```
 gcc -m64 -z execstack -fno-stack-protector Test.c -o Test -no-pie
```

## Analysis
 tl;dr: The shellcode basically does the following

 ```
 execve("/bin/sh", ["/bin/sh", "-c", "whoami"], 0);
 ```
    
 As we can see it starts /bin/sh with the -c command. The -c command tells the started SH not to be interactive, but to execute one single command ('whomai' in this case) and then exit.

It is important to understand that the second parameter is not a single string, but a char pointer array. The last parameter can be left blank as it would only specify environment variables that we dont need here.


 1.
     push 0x3b ; pop rax => sycall execve in rax
     cdq -> clear out rdx

 2.
     movabs rbx, "/bin/sh"
     push rbx
     mov rdi, rsp -> rdi now points to /bin/sh

3. 
    push "-c"
    mov rsi, rsp -> rsi now points to -c. Argument for /bin/sh not to spawn a shell but to exec one single command

4. 
    
    call   0x7fffffffdd57
    // Creating the argv array on the stack
    // Stack:
    //    /bin/sh
    //    -c
    //    whoami
    push rsi ("-c")
    push rdi ("/bin/sh")  
    
    syscall

    rdi points to /bin/sh
    rdi points to argv[] on the stack
