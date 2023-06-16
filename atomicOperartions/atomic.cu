#include <iostream>
using std::cout;
using std::endl;

__global__ void incrementVariable(int* result) {
    atomicAdd(result, 1);
}

int main() {

    int hostResult = 0;
    int* deviceResult;
    cudaMalloc((void**)&deviceResult, sizeof(int));
    cudaMemcpy(deviceResult, &hostResult, sizeof(int), cudaMemcpyHostToDevice);

    // Launch the kernel
    int numThreads = 256;
    incrementVariable<<<1, numThreads>>>(deviceResult);

    // Copy the result back to the host
    cudaMemcpy(&hostResult, deviceResult, sizeof(int), cudaMemcpyDeviceToHost);

    cudaFree(deviceResult);

    // Print the result
    cout << "Final value: " << hostResult << endl;

    return 0;
}