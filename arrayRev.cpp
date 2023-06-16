index = 0
end = size - 1

while(index < size / 2)
{
    float temp = array[index];
    array[index] = array[end];
    array[end] = array[index];

    index++;
    end--;
}