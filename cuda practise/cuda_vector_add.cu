#include <iostream>
#include <cuda_runtime.h>

__global__ void vectorAdd(int *a, int *b, int *c, int size) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < size) {
        c[i] = a[i] + b[i];
    }
}

int main() {
    const int size = 1000000;
    const int threadsPerBlock = 256;
    const int blocksPerGrid = (size + threadsPerBlock - 1) / threadsPerBlock;

    int *hostA, *hostB, *hostC;
    int *deviceA, *deviceB, *deviceC;

    // Allocate host memory
    hostA = new int[size];
    hostB = new int[size];
    hostC = new int[size];

    // Initialize host arrays
    for (int i = 0; i < size; ++i) {
        hostA[i] = i;
        hostB[i] = i * 2;
    }

    // Allocate device memory
    cudaMalloc((void**)&deviceA, size * sizeof(int));
    cudaMalloc((void**)&deviceB, size * sizeof(int));
    cudaMalloc((void**)&deviceC, size * sizeof(int));

    // Copy data from host to device
    cudaMemcpy(deviceA, hostA, size * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(deviceB, hostB, size * sizeof(int), cudaMemcpyHostToDevice);

    // Launch the kernel
    vectorAdd<<<blocksPerGrid, threadsPerBlock>>>(deviceA, deviceB, deviceC, size);

    // Copy result from device to host
    cudaMemcpy(hostC, deviceC, size * sizeof(int), cudaMemcpyDeviceToHost);

    // Free device memory
    cudaFree(deviceA);
    cudaFree(deviceB);
    cudaFree(deviceC);

    // Free host memory
    delete[] hostA;
    delete[] hostB;
    delete[] hostC;

    return 0;
}
