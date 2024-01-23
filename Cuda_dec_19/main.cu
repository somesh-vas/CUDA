#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "crypto_kem.h"
#include "decrypt.h"
#include "params.h"

int
main()
{
    
    int tv; //test_vector
    
    // unsigned char *ss1 = 0;
    // unsigned char *ss2 = 0;  
    unsigned char *sk1 = 0;
    unsigned char *ct1 = 0;      

    
    //  char sessionkeys[KATNUM][65];
    char ciphertexts[KATNUM][193];
     char secretkeys[KATNUM][12985];
    //  int random_error[KATNUM];
    
    //FILE *file = fopen("ss1.txt", "r");
    FILE *file1 = fopen("ct1.txt", "r");
    FILE *file2 = fopen("sk1.txt", "r");
    // FILE *file = fopen()
    FILE *file = fopen("ee.txt", "r");
    
    int error_encrypt_positions[KATNUM][64];
    //int error_decrypt_positions[64];

    if ( file == NULL || file1 == NULL || file2 == NULL) {
        perror("Error opening file");
        return 1;
    }    
    

    for (int i = 0; i < KATNUM; i++) {
        for (int j = 0; j < 64; j++) {
            if (fscanf(file, "%d", &error_encrypt_positions[i][j]) != 1) {
                printf("Error reading from file.\n");
                fclose(file);
                return 1;
            }
        }
    }

    // Read and store the content in the sessionkey array
    for (int i = 0; i < KATNUM; ++i) {
        if (fscanf(file2, "%12984s", secretkeys[i]) != 1) {
            fprintf(stderr, "Error reading from file");
            fclose(file2);
            return 1;
        }
    }
    

    for (int i = 0; i < KATNUM; ++i) {
        if (fscanf(file1, "%192s", ciphertexts[i]) != 1) {
            fprintf(stderr, "Error reading from file");
            fclose(file1);
            return 1;
        }
    }

    
    

    for (tv=0; tv<KATNUM; tv++) {        
             
        // Allocate memory for sk1
if (!(sk1 = (unsigned char*)malloc(crypto_kem_SECRETKEYBYTES))) {
    fprintf(stderr, "Memory allocation error for sk1.\n");
    abort();
}

// Allocate memory for ct1
if (!(ct1 = (unsigned char*)malloc(crypto_kem_CIPHERTEXTBYTES))) {
    fprintf(stderr, "Memory allocation error for ct1.\n");
    abort();
}

        

    
    for (int i = 0; i < crypto_kem_CIPHERTEXTBYTES; i++) {
        sscanf(ciphertexts[tv] + 2 * i, "%2hhX", &ct1[i]);
    }
    for (int i = 0; i < crypto_kem_SECRETKEYBYTES; i++) {
        sscanf(secretkeys[tv] + 2 * i, "%2hhX", &sk1[i]);
    }
    
             
        unsigned char e[ SYS_N / 8];
        
        decrypt(e, sk1 + 40, ct1);
        int k;
        int count = 0;
        int flag[64] = {0};
        for (k = 0; k < SYS_N; ++k) {
            
        if (e[k / 8] & (1 << (k & 7))) {
            //error_decrypt_positions[k];
            if(error_encrypt_positions[tv][count] != k){
                flag[count] = k;
                break;
                
            }
        
            }
            count ++;
        }
        

            
        
    }
    free(sk1);
    free(ct1);
    // free(e);
    return KAT_SUCCESS;
}

