#include <iostream>
#include <cuda_runtime.h>

// Kernel function to reverse an array on the GPU
__global__ void reverseArray(float* array, int size) {
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int reverseIndex = size - index - 1;

    if (index < size / 2) {
        float temp = array[index];
        array[index] = array[reverseIndex];
        array[reverseIndex] = temp;
    }
}

int main() {
    // Size of the array
    int arraySize = 10;

    // Allocate memory for the array on the host
    float* hostArray = new float[arraySize];

    // Initialize the array
    for (int i = 0; i < arraySize; ++i) {
        hostArray[i] = static_cast<float>(i);
    }

    // Allocate memory for the array on the device
    float* deviceArray;
    cudaMalloc((void**)&deviceArray, arraySize * sizeof(float));

    // Copy the array from host to device
    cudaMemcpy(deviceArray, hostArray, arraySize * sizeof(float), cudaMemcpyHostToDevice);

    // Launch the kernel
    int blockSize = 256;
    int gridSize = (arraySize + blockSize - 1) / blockSize;
    reverseArray<<<gridSize, blockSize>>>(deviceArray, arraySize);

    // Copy the reversed array back to the host
    cudaMemcpy(hostArray, deviceArray, arraySize * sizeof(float), cudaMemcpyDeviceToHost);

    // Cleanup
    delete[] hostArray;
    cudaFree(deviceArray);

    // Print the reversed array
    std::cout << "Reversed array: ";
    for (int i = 0; i < arraySize; ++i) {
        std::cout << hostArray[i] << " ";
    }
    std::cout << std::endl;

    return 0;
}
