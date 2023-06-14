#include <iostream>
#include <vector>
#include <iterator>
#include <algorithm>
#include <functional>
#include <chrono>
#include <cassert>
#include <thread>

#define NUM_OF_THREADS 8
#define VECTOR_SIZE    50000000

using time_point = std::chrono::high_resolution_clock::time_point;

template<typename T>
std::vector<T> operator+(std::vector<T> const& first, std::vector<T> const& second)
{
    assert(first.size() == second.size());

    std::vector<T> result;
    result.reserve(first.size());

    std::transform(first.begin(), first.end(), second.begin(), std::back_inserter(result), std::plus<T>());
    return result;
}

template<typename T>
void parallel_addition(std::vector<T>& result,
                       std::vector<T> const& first,
                       std::vector<T> const& second,
                       size_t lower_bound,
                       size_t upper_bound)
{
    for (size_t i = lower_bound; i < upper_bound; i++)
    {
        result[i] = first[i] + second[i];
    }
}

int main(int argc, char *argv[])
{
    std::vector<int> first_vec, second_vec;

    /* Filling up the vectors with dummy values */
    for (int i = 1; i <= VECTOR_SIZE; i++)
    {
        first_vec.push_back(i);
        second_vec.push_back(i);
    }

    /* Sequential addition of vectors */
    time_point t1_seq = std::chrono::high_resolution_clock::now();
    std::vector<int> sequential_result = first_vec + second_vec;
    time_point t2_seq = std::chrono::high_resolution_clock::now();
    auto duration_seq = std::chrono::duration<double>(t2_seq - t1_seq).count();
    std::cout << "Sequential addition of vectors - execution time: " << duration_seq << " seconds" << std::endl;

    /* Parallel addition of vectors */
    std::vector<std::thread> threads;
    std::vector<int> parallel_result(VECTOR_SIZE);

    time_point t1_par = std::chrono::high_resolution_clock::now();

    auto range = std::size(first_vec) / NUM_OF_THREADS;
    for (int i = 0; i < NUM_OF_THREADS; i++)
    {
        auto start = i * range;
        auto firstBegin = std::begin(first_vec) + start;
        auto secondBegin = std::begin(second_vec) + start;
        auto resultBegin = std::begin(parallel_result) + start;

        auto firstEnd = firstBegin + range;
        threads.emplace_back(
            [firstBegin, firstEnd, secondBegin, resultBegin]()
            {
                std::transform(firstBegin, firstEnd, secondBegin, resultBegin, std::plus<int>());
            }
        );
    }


    for (auto &thread : threads)
    {
        thread.join();
    }

    time_point t2_par = std::chrono::high_resolution_clock::now();
    auto duration_par = std::chrono::duration<double>(t2_par - t1_par).count();
    std::cout << "Parallel (" << NUM_OF_THREADS << " threads) addition of vectors - execution time: " << duration_par << " seconds" << std::endl;

    return 0;
}