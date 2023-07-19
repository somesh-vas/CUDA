
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

cudaError_t addWithCuda(int *c, const int *a, const int *b, unsigned int size);

__global__ void hello_cuda()
{
	printf("hello cuda\n");
}

int main() {
	dim3 block(4, 1, 1);
	dim3 grid(8, 1, 1);
	hello_cuda << < grid, block >> > ();
	cudaDeviceSynchronize();
	cudaDeviceReset();
	return 0;
}

