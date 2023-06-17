#include <iostream>
using std::cout; using std::endl;

__global__ void reverseArray(float *array, int size)
{
    int index = blockIdx.x * blockDim.x + threadIdx.x;
    int reverseIndex = size - index - 1;

    // TODO: fill this out
    if(index < size / 2)
    {
        float temp = array[index];
        array[index] = array[reverseIndex];
        array[reverseIndex] = temp;
    }
}

int main()
{
    int arraySize = 10000000000000000;

    //! Allocate host memory for the array 
    float *h_array = new float[arraySize];

    //! Initialize the array
    for (int i = 0; i < arraySize; ++i)
    {
        h_array[i] = static_cast<float>(i);
    }

    //! Device mem allocation
    float *d_array;
    cudaMalloc((void **)&d_array, arraySize * sizeof(float));
    cudaMemcpy(d_array, h_array, arraySize * sizeof(float), cudaMemcpyHostToDevice);

    //! block size and grid size
    int blockSize = 256;
    int numBlocks = (arraySize + blockSize - 1) / blockSize;
    reverseArray<<<numBlocks, blockSize>>>(d_array, arraySize);
    cudaDeviceSynchronize();

    cudaMemcpy(h_array, d_array, arraySize * sizeof(float), cudaMemcpyDeviceToHost);

    for(int i = 0; i < arraySize; ++i)
    {
        cout << h_array[i] << " ";
    }

    // cleanup
    delete[] h_array;
    cudaFree(d_array);

    return 0;
}