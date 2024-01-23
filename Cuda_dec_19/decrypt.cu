#include <stdio.h>
#include "decrypt.h"
#include "params.h"
#include <cuda_runtime.h>
typedef unsigned short uint16_t;
typedef uint16_t gf;


int decrypt(unsigned char *e, const unsigned char *sk, const unsigned char *c){
    gf g[ SYS_T+1 ]; // goppa polynomial
    gf L[ SYS_N ]; // support

    // Call the host function to compute g
    compute_g_host(g, sk);
    support_gen(L, sk);
    

return 1;
}
