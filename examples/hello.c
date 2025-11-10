#include <stdio.h>
#include <stdlib.h>

int main() {
    printf("Hello, Fil-C World!\n");
    printf("This is a memory-safe C compiler!\n");
    
    // Test some basic memory allocation
    int *numbers = malloc(5 * sizeof(int));
    if (numbers == NULL) {
        printf("Memory allocation failed!\n");
        return 1;
    }
    
    // Fill array with some values
    for (int i = 0; i < 5; i++) {
        numbers[i] = i * i;
    }
    
    printf("Squares: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");
    
    free(numbers);
    printf("Memory freed successfully!\n");
    
    return 0;
}