import argparse
import random
import sys

def main(shellcode_raw, key):

    shellcode_raw = shellcode_raw.split('\\x')[1:]
    shellcode_raw = [int(y, 16) for y in shellcode_raw]
    shellcode_enc = []
    
    last = key
    for x in shellcode_raw:
        x ^= last
        last = x
        shellcode_enc.append(x)
    
    print "Encoded with XOR and arithmetic:"
    print ''.join(['\\' + hex(x)[1:] for x in shellcode_enc])
    for_asm = ''.join([","+hex(x) for x in shellcode_enc])

    with open("Decoder_ExecveSTUB.asm", "r") as f:
        contents = f.read()
        contents = contents % (chr(key), len(shellcode_raw), for_asm[1:])
        f.close()
        
    with open("Decoder_Execve.asm", "w") as f:
        f.write(contents)
        f.close()

if __name__ == "__main__":

    parser = argparse.ArgumentParser()
    parser.add_argument("-sh", required=True)
    parser.add_argument("-k", required=True)
    args = parser.parse_args()

    main(args.sh, ord(args.k))
