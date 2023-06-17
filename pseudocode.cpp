// array = [1, 2, 3, 4, 5, 6]

// var1 = start (1) <- indices
// var2 = end (6)

// array[var1] = array[var2]
// array[var2] = array[var1]

[6, 5, 4, 3, 2, 1]

array = [...]
size = array.length()

index = 0
end = size - 1

while(index < size / 2)
{
    float temp = array[index];
    array[index] = array[end];
    array[end] = temp;

    index++;
    end--;
}
