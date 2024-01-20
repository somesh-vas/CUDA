#include <iostream>
#include <cuda_runtime.h>

int main() {
    cudaDeviceProp prop;
    int device;

    // Get the device count
    cudaGetDeviceCount(&device);

    if (device == 0) {
        std::cerr << "No CUDA-capable device found." << std::endl;
        return 1;
    }

    // Get device properties
    cudaGetDeviceProperties(&prop, 0);  // Assuming you are using the first GPU

    // Print device information
    std::cout << "Device Name: " << prop.name << std::endl;
    std::cout << "Global Memory: " << prop.totalGlobalMem << " bytes" << std::endl;
    std::cout << "Shared Memory Per Block: " << prop.sharedMemPerBlock << " bytes" << std::endl;
    std::cout << "Constant Memory: " << prop.totalConstMem << " bytes" << std::endl;
    std::cout << "Texture Memory: " << prop.textureAlignment << " bytes" << std::endl;
    std::cout << "Local Memory Per Block: " << prop.localMemoryPerBlock << " bytes" << std::endl;

    return 0;
}
