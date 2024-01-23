#include "decrypt.h"
#include "params.h"
#include <cuda_runtime.h>
#include <stdio.h>


typedef unsigned short uint16_t;
typedef uint16_t gf;



__device__ uint16_t load_gf(const unsigned char *src) {
    uint16_t a;

    a = src[1];
    a <<= 8;  // Left-shift by 8 bits (one byte)
    a |= src[0];

    return a & GFMASK;
}

__global__ void compute_g_cuda(uint16_t *g, const unsigned char *sk) {
    int tid = threadIdx.x + blockIdx.x * blockDim.x;

    if (tid < SYS_T) {
        g[tid] = load_gf(sk + 2 * tid);
    }
}
void compute_g_host(uint16_t *h_g, const unsigned char *h_sk) {
    // Allocate memory on the GPU
    uint16_t *d_g;
    unsigned char *d_sk;
    cudaMalloc((void**)&d_g, SYS_T * sizeof(uint16_t));
    cudaMalloc((void**)&d_sk, 2 * SYS_T * sizeof(unsigned char));

    // Copy data from host to device
    cudaMemcpy(d_sk, h_sk, 2 * SYS_T * sizeof(unsigned char), cudaMemcpyHostToDevice);

    // Define block and grid dimensions
    dim3 blockDim(256);
    dim3 gridDim((SYS_T + blockDim.x - 1) / blockDim.x);

    // Launch the CUDA kernel
    compute_g_cuda<<<gridDim, blockDim>>>(d_g, d_sk);

    // Synchronize to wait for the kernel to finish
    cudaDeviceSynchronize();

    // Copy the result from device to host
    cudaMemcpy(h_g, d_g, SYS_T * sizeof(uint16_t), cudaMemcpyDeviceToHost);

    // Print the computed values of g
    printf("Computed g: ");
    for (int i = 0; i < SYS_T; ++i) {
        printf("%04X ", h_g[i]);
    }
    printf("\n");

    // Free allocated memory on the GPU
    cudaFree(d_g);
    cudaFree(d_sk);
}