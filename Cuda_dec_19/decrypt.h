/*
  This file is for Nieddereiter decryption
*/

#ifndef DECRYPT_H
#define DECRYPT_H
// #include "function.cu"
int decrypt(unsigned char *, const unsigned char *, const unsigned char *);

#include "params.h"

// Declare the function prototypes
typedef unsigned short uint16_t;
typedef uint16_t gf;


__device__ uint16_t load_gf(const unsigned char *src);
__global__ void compute_g_cuda(uint16_t *g, const unsigned char *sk);
void compute_g_host(uint16_t *h_g, const unsigned char *h_sk);

#endif

