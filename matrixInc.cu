/*
Program to add 2 matrics of size M * N in CUDA C++
Using 2-D grid of M*N size (i.e. grid contains M*N blocks arranged in 2D fashion)
Each block contains 1 thread
*/
#include<iostream>
using std::cout; using std::endl;

#define M 7
#define N 3

__global__ void matAdd(int* a, const int increment)
{
    int idx = blockIdx.x * gridDim.y + blockIdx.y;
    a[idx] = a[idx] + increment;
}

__host__ void print_matrix(int* matrix)
{
    for(int i=0; i<M; ++i)
    {
        for(int j=0; j<N; ++j)
        {
            cout<<matrix[i*N+j]<<' ';
        }
        cout<<"\n";
    }
    cout<<"\n";
}

int main()
{
    int size = M * N * sizeof(int);
    int* a = new int[size];

    for(int i=0; i<M; ++i)
    {
        for(int j=0; j<N; ++j)
        {
            a[i*N + j] = i; //Fill your own values here
        }
    }

    print_matrix(a);

    /* Setting up variables on device. i.e. GPU */
    int *d_a;
    cudaMalloc((void**)&d_a, size);

    /* Copy data from host to device */
    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);

    dim3 gridSize(M, N);
    matAdd<<<gridSize, 1>>>(d_a, 3);
    cudaDeviceSynchronize();

    /* Copy result from GPU device to host */
    cudaMemcpy(a, d_a, size, cudaMemcpyDeviceToHost);
    
    /* Print result */
    print_matrix(a);

    /* Cleanup device and host memory */
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    delete a;
    delete b;
    delete c;

    return 0;
}