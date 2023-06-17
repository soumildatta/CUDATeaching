#include <iostream>
using std::cout;
using std::endl;

__global__ void matAdd(int *a, int *b, int *c)
{
    int index = blockIdx.x * gridDim.y + blockIdx.y;
    c[index] = a[index] + b[index];
}

void print_matrix(int *matrix, int M, int N)
{
    for(int i = 0; i < M; ++i)
    {
        for(int j = 0; j < N; ++j)
        {
            cout << matrix[i * N + j] << " ";
        }
        cout << endl;
    }
}

int main()
{
    int M = 7; // num rows
    int N = 3; // num cols

    int size = M * N * sizeof(int);

    // Allocate memory for new matrices
    int *a = new int[size];
    int *b = new int[size];
    int *c = new int[size];

    for(int i = 0; i < M; ++i)
    {
        for(int j = 0; j < N; ++j)
        {
            a[i * N + j] = i;
            b[i * N + j] = j;
        }
    }

    int *d_a;
    int *d_b;
    int *d_c;
    cudaMalloc((void **)&d_a, size);
    cudaMalloc((void **)&d_b, size);
    cudaMalloc((void **)&d_c, size);

    cudaMemcpy(d_a, a, size, cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, size, cudaMemcpyHostToDevice);

    dim3 gridSize(M, N);
    matAdd<<<gridSize, 1>>>(d_a, d_b, d_c);
    cudaDeviceSynchronize();

    cudaMemcpy(c, d_c, size, cudaMemcpyDeviceToHost);

    print_matrix(a, M, N);
    cout << endl;
    print_matrix(b, M, N);
    cout << endl;
    print_matrix(c, M, N);
    cout << endl;

    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);
    free(a);
    free(b);
    free(c);

    return 0;
}