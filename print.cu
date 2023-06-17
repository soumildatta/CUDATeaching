#include<iostream>
using std::cout;
using std::endl;

__global__ void printKernel()
{
    printf("%d", threadIdx.x);
}

int main()
{
    // cout << "Hello World" << endl;
    printKernel<<<1, 10>>>();
    cudaDeviceSynchronize();

    return 0;
}