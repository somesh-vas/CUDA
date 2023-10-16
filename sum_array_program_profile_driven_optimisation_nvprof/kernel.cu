
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size);

#include <stdio.h>
#include <stdlib.h>

// CUDA kernel to compute the sum of an array
__global__ void sumArray(int* d_array, int* d_result, int N) {
    int tid = threadIdx.x + blockIdx.x * blockDim.x;
    int step = gridDim.x * blockDim.x;

    int sum = 0;
    for (int i = tid; i < N; i += step) {
        sum += d_array[i];
    }
    d_result[tid] = sum;
}

int main() {
    int N = 1024; // Array size
    int* h_array, * d_array, * d_result;
    int result = 0;

    // Allocate host and device memory
    h_array = (int*)malloc(N * sizeof(int));
    cudaMalloc((void**)&d_array, N * sizeof(int));
    cudaMalloc((void**)&d_result, N * sizeof(int));

    // Initialize host array
    for (int i = 0; i < N; i++) {
        h_array[i] = i;
    }

    // Copy data from host to device
    cudaMemcpy(d_array, h_array, N * sizeof(int), cudaMemcpyHostToDevice);

    // Define thread block and grid dimensions
    dim3 blockDim(256);
    dim3 gridDim((N + blockDim.x - 1) / blockDim.x);

    // Launch the kernel
    sumArray << <gridDim, blockDim >> > (d_array, d_result, N);

    // Copy the result from device to host
    cudaMemcpy(&result, d_result, sizeof(int), cudaMemcpyDeviceToHost);

    printf("Sum: %d\n", result);

    // Cleanup
    free(h_array);
    cudaFree(d_array);
    cudaFree(d_result);

    return 0;
}
