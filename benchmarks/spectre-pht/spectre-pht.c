#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

#define SIZE 16                 /* Size fo secretarray and publicarray */
uint32_t publicarray_size = 16;

// Public values
uint8_t publicarray[SIZE] = { 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 };
uint8_t publicarray2[SIZE] = { 20 };

// The attacker's goal in all of these examples is to learn any of the secret data in secretarray
uint8_t secretarray[SIZE] __attribute__((used)) = { 10,21,32,43,54,65,76,87,98,109,110,121,132,143,154,165 };

// This is mostly used to prevent the compiler from optimizing out certain operations
volatile uint8_t temp = 0;

// ----------------------------------------------------------------------------------------
// EXAMPLE 1:  This is the sample function from the Spectre paper.
// ----------------------------------------------------------------------------------------
void victim_function_v1(size_t x) {
     if (x < publicarray_size) {
          temp &= publicarray2[publicarray[x]];
     }
}

// ----------------------------------------------------------------------------------------
// EXAMPLE 2:  Moving the leak to a local function that can be inlined.
// ----------------------------------------------------------------------------------------
void leakByteLocalFunction(uint8_t k) { temp &= publicarray2[(k)]; }
void victim_function_v2(size_t x) {
     if (x < publicarray_size) {
          leakByteLocalFunction(publicarray[x]);
     }
}
// ----------------------------------------------------------------------------------------
// EXAMPLE 3:  Moving the leak to a function that cannot be inlined.
//
// Comments: Output is unsafe.  The same results occur if leakByteNoinlineFunction()
// is in another source module.
// ----------------------------------------------------------------------------------------
__attribute__ ((noinline)) void leakByteNoinlineFunction(uint8_t k) { temp &= publicarray2[(k)]; }
void victim_function_v3(size_t x) {
     if (x < publicarray_size)
          leakByteNoinlineFunction(publicarray[x]);
}
// ----------------------------------------------------------------------------------------
// EXAMPLE 4:  Add a left shift by one on the index.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v4(size_t x) {
     if (x < publicarray_size)
          temp &= publicarray2[publicarray[x << 1]];
}

// ----------------------------------------------------------------------------------------
// EXAMPLE 5:  Use x as the initial value in a for() loop.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v5(size_t x) {
     int i;
     if (x < publicarray_size) {
         for (i = x - 1; i >= 0; i--) {
               temp &= publicarray2[publicarray[i]];
         }
     }
}

// ----------------------------------------------------------------------------------------
// EXAMPLE 6:  Check the bounds with an AND mask, rather than "<".
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
int array_size_mask = 15;
void victim_function_v6(size_t x) {
     if ((x & array_size_mask) == x)
          temp &= publicarray2[publicarray[x]];
}

// ----------------------------------------------------------------------------------------
// EXAMPLE 7:  Compare against the last known-good value.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v7(size_t x) {
     static size_t last_x = 0;
     if (x == last_x)
          temp &= publicarray2[publicarray[x]];
     if (x < publicarray_size)
          last_x = x;
}

// ----------------------------------------------------------------------------------------
// EXAMPLE 8:  Use a ?: operator to check bounds.
// ----------------------------------------------------------------------------------------
void victim_function_v8(size_t x) {
     temp &= publicarray2[publicarray[x < publicarray_size ? (x + 1) : 0]];
}

// ----------------------------------------------------------------------------------------
// EXAMPLE 9:  Use a separate value to communicate the safety check status.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v9(size_t x, int *x_is_safe) {
     if (*x_is_safe)
          temp &= publicarray2[publicarray[x]];
}
// ----------------------------------------------------------------------------------------
// EXAMPLE 10:  Leak a comparison result.
//
// Comments: Output is unsafe.  Note that this vulnerability is a little different, namely
// the attacker is assumed to provide both x and k.  The victim code checks whether
// publicarray[x] == k.  If so, the victim reads from publicarray2[0].  The attacker can try
// values for k until finding the one that causes publicarray2[0] to get brought into the cache.
// ----------------------------------------------------------------------------------------
void victim_function_v10(size_t x, uint8_t k) {
     if (x < publicarray_size) {
          if (publicarray[x] == k)
               temp &= publicarray2[0];
     }
}

// ----------------------------------------------------------------------------------------
// EXAMPLE 11:  Use memcmp() to read the memory for the leak.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v11(size_t x) {
     if (x < publicarray_size)
          temp = memcmp(&temp, publicarray2 + (publicarray[x]), 1);
}
// ----------------------------------------------------------------------------------------
// EXAMPLE 12:  Make the index be the sum of two input parameters.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v12(size_t x, size_t y) {
     if ((x + y) < publicarray_size)
          temp &= publicarray2[publicarray[x + y]];
}

// ----------------------------------------------------------------------------------------
// EXAMPLE 13:  Do the safety check into an inline function
//
// Comments: Output is unsafe. We removed the "__inline" since anyways BMC inlines all the calls
// ----------------------------------------------------------------------------------------
int is_x_safe(size_t x) {
    if (x < publicarray_size) {
        return 1;
    }
    return 0;
}
void victim_function_v13(size_t x) {
     if (is_x_safe(x))
          temp &= publicarray2[publicarray[x]];
}
// ----------------------------------------------------------------------------------------
// EXAMPLE 14:  Invert the low bits of x
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v14(size_t x) {
     if (x < publicarray_size)
          temp &= publicarray2[publicarray[x ^ 255]];
}

// ----------------------------------------------------------------------------------------
// EXAMPLE 15:  Pass a pointer to the length
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v15(size_t *x) {
     if (*x < publicarray_size)
          temp &= publicarray2[publicarray[*x]];
}

int main() {
    return 0;
}
