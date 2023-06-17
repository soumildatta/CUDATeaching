#include <iostream>
using std::cout;
using std::endl;

__global__ void add(int *result)
{
    // result += 1;
    atomicAdd(result, 1);
}

int main()
{
    int h_result = 0;

    int *d_result;
    cudaMalloc((void **)&d_result, sizeof(int));
    cudaMemcpy(d_result, &h_result, sizeof(int), cudaMemcpyHostToDevice);

    int numThreads = 256;
    int numBlocks = 1;

    //! Kernel Invocation
    add<<<numBlocks, numThreads>>>(d_result);

    //! Device Sync
    cudaDeviceSynchronize();

    //! Memcopy back to host 
    cudaMemcpy(&h_result, d_result, sizeof(int), cudaMemcpyDeviceToHost);

    //! Free memory
    cudaFree(d_result);

    //! Print result
    cout << "Final result: " << h_result << endl;

    return 0;
}