#include <stdio.h>

__global__ void printThreadInfo() {
    int threadIdX = threadIdx.x;
    int threadIdY = threadIdx.y;
    int threadIdZ = threadIdx.z;

    int blockIdX = blockIdx.x;
    int blockIdY = blockIdx.y;
    int blockIdZ = blockIdx.z;

    int gridDimX = gridDim.x;
    int gridDimY = gridDim.y;
    int gridDimZ = gridDim.z;

    printf("ThreadIdx: (%d, %d, %d)\n", threadIdX, threadIdY, threadIdZ);
    printf("BlockIdx: (%d, %d, %d)\n", blockIdX, blockIdY, blockIdZ);
    printf("GridDim: (%d, %d, %d)\n", gridDimX, gridDimY, gridDimZ);
}

int main() {
    dim3 blockDimensions(2, 2, 2); // 2 threads in each dimension for the block
    dim3 gridDimensions(2, 2, 2);   // 4 threads in all dimensions for the grid

    printThreadInfo << <gridDimensions, blockDimensions >> > ();
    cudaDeviceSynchronize(); // Wait for the GPU to finish

    return 0;
}
