#include <iostream>
using std::cout;
using std::endl;

int main()
{
    size_t size = 500000000;

    //! HOST DATA INITIALIZATION
    // Allocate array on CPU
    float *h_array = (float *)malloc(size);
    // Add values to array on CPU
    for(int i = 0; i < size; ++i)
    {
        h_array[i] = (float)(rand()) / (float)(rand());
    }

    //! DEVICE INITIALIZATION
    float *d_array = NULL;
    cudaMalloc((void **)&d_array, size);
    cudaMemcpy(d_array, h_array, size, cudaMemcpyHostToDevice);

    float *result = (float *)malloc(sizeof(float));
    result[0] = 0;
    
    float *d_result = NULL;
    cudaMalloc((void **)&result, sizeof(float));
    cudaMemcpy(result, sizeof(float), cudaMemcpyHostToDevice);

    return 0;
}