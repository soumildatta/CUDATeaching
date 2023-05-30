#include <thread>
using std::thread;

int main(int argc, char* argv[])
{
    unsigned int dimension = atoi(argv[1]);

    // Max hardware threads that can be run
    unsigned int numThreads = thread::hardware_concurrency();

    // Create two matrices 
    float *mat1 = (float *)malloc(dimension * sizeof(float));
    float *mat2 = (float *)malloc(dimension * sizeof(float));

    

    free(mat1);
    free(mat2);

    return 0;
}