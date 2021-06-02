#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

#define SIZE 16                 /* Size fo secretarray and publicarray */
uint32_t idx_array_size = 2;

// Public values
uint8_t idx_array[2] = { 0,0 };
uint8_t publicarray[SIZE] = { 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 };
uint8_t publicarray2[SIZE] = { 20 };

// The attacker's goal in all of these examples is to learn any of the secret data in secretarray
uint8_t secretarray[SIZE] __attribute__((used)) = { 10,21,32,43,54,65,76,87,98,109,110,121,132,143,154,165 };

// This is mostly used to prevent the compiler from optimizing out certain operations
volatile uint8_t temp = 0;

void victim_function_v1(uint8_t idx) {
     if (idx < idx_array_size) {
         idx_array[0] = 64;
         temp &= publicarray2[publicarray[idx_array[idx] * idx]];
     }
}

int main() {
    return 0;
}
