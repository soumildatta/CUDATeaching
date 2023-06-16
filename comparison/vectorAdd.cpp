#include <iostream>
using std::cout;
using std::endl;

#include <thread>
using std::thread;

#include <vector>
using std::vector;

// #include <cuda_runtime.h>

// __global__ void vectorAdd(float *vec1, float *vec2, float *result, const unsigned int size)
// {

// }

void parallelVectorAdd(float *vec1, float *vec2, unsigned int dim, unsigned int threadID, unsigned int numThreads, float *result)
{
    cout << (unsigned int)(dim / threadID) << endl;
    // unsigned int chunkBegin = (unsigned int)(dim / threadID) * threadID;
    // unsigned int chunkEnd   = (unsigned int)(dim / threadID) * (threadID + 1);

    // for(unsigned int i = chunkBegin; i < chunkEnd; ++i)
    // {
    //     cout << chunkBegin << " " << chunkEnd << endl;
    // }
}

int main(int argc, char* argv[])
{
    unsigned int dimension = atoi(argv[1]);

    // Max hardware threads that can be run
    unsigned int numThreads = thread::hardware_concurrency();
    cout << numThreads << endl;

    // Create two matrices 
    float *vec1 = (float *)malloc(dimension * sizeof(float));
    float *vec2 = (float *)malloc(dimension * sizeof(float));
    float *result = (float *)malloc(dimension * sizeof(float));
    // Assign values to arrays 
    srand(time(0));
    for (int i = 0; i < dimension; ++i)
    {
        vec1[i] = (float)(rand()) / (float)(rand());
        vec2[i] = (float)(rand()) / (float)(rand());
    }

    // Start threads for calculation
    vector<thread> workers;
    for (unsigned int i = 0u; i < numThreads; ++i)
        workers.emplace_back(thread(&parallelVectorAdd, vec1, vec2, dimension, i, numThreads, std::ref(result)));
    
    for (thread& worker : workers)
        worker.join();

    for (int i = 0; i < dimension; ++i)
    {
        cout << result << endl;
    }

    free(vec1);
    free(vec2);
    free(result);

    return 0;
}