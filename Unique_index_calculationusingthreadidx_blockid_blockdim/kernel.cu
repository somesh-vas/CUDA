
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

//cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size);

__global__ void uniq(int * input)
{
    int tid = threadIdx.x;
    printf("threadIdx : %d, value : %d \n", tid, input[tid]);
}
__global__ void uniq_grid_1d(int* input) {
    int tid = threadIdx.x;
    int offset = blockIdx.x * blockDim.x;
    int gid = tid + offset;
    printf("blockIdx.x : %d, threadIdx.x : %d, grid : %d, value : %d \n",
        blockIdx.x, tid, gid, input[gid]);
}
__global__ void uniq_grid_2d(int* input) {
    int tid = threadIdx.x;
    int block_offset = blockIdx.x * blockDim.x;
    int row_offset = blockDim.x * gridDim.x * blockIdx.y;
    int gid = tid + block_offset + row_offset;
    printf("blockIdx.x : %d,blockIdx.y : %d, threadIdx.x : %d, grid : %d, value : %d \n",
        blockIdx.x,blockIdx.y, tid, gid, input[gid]);
}
__global__ void uniq_grid_2d_2d(int* input) {
    int tid = blockDim.x * threadIdx.y + threadIdx.x;
    int num_threads_in_a_block = blockDim.x * blockDim.y;
    int block_offset = blockIdx.x * num_threads_in_a_block;
    int num_threads_in_a_row = num_threads_in_a_block * gridDim.x;
    int row_offset = num_threads_in_a_row * blockIdx.y;
    int gid = tid + block_offset + row_offset;
    printf("blockIdx.x : %d,blockIdx.y : %d, threadIdx.x : %d, grid : %d, value : %d \n",
        blockIdx.x, blockIdx.y, tid, gid, input[gid]);
}


/*
* index =(blockIdx.X X blockDim.X) + threadIdx.X
* index = offset + tid
* 
* general index calculation
* index = row offset + block offset + tid
* index = (number of threads in one thread block row * blockIdx.y) + number of threads in * thread block * blockIdx.x + threadIdx.x
* 
* -- number of threads in one row = gridDim.x * blockDim.x
* -- number of threads in thread block = blockDim.x
*/
int main() {
    int array_size = 16;
    int array_byte_size = sizeof(int) * array_size;
    int h_data[16];

    for (int i = 0; i < array_size; i++) {
        h_data[i] = i + 1;
        printf("%d ", h_data[i]);
    }

    printf("\n \n");

    int* d_data;
    cudaMalloc((void**)&d_data, array_byte_size);
    cudaMemcpy(d_data, h_data, array_byte_size, cudaMemcpyHostToDevice);

    dim3 block(2,2);
    dim3 grid(2,2);

    uniq_grid_2d_2d<< < grid, block >> > (d_data);
    cudaDeviceSynchronize();

    cudaDeviceReset();
    return 0;
}