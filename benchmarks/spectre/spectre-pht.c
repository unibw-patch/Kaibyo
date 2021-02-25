#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

#ifdef klee
#include <klee/klee.h>
#endif

#ifdef zombmc
extern size_t __VERIFIER_nondet_long(void);
extern int __VERIFIER_nondet_int(void);
#endif

uint32_t publicarray_size = 16;
uint8_t publicarray[16] = { 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 };
uint8_t publicarray2[64];

uint8_t secret __attribute__((used));

uint8_t temp = 0; /* Used so compiler won’t optimize out victim_function() */

#ifdef v1
// ----------------------------------------------------------------------------------------
// EXAMPLE 1:  This is the sample function from the Spectre paper.
// ----------------------------------------------------------------------------------------
void victim_function_v1(size_t x) {
     if (x < publicarray_size) {
          temp &= publicarray2[publicarray[x]];
     }
}
#endif

#ifdef v2
// ----------------------------------------------------------------------------------------
// EXAMPLE 2:  Moving the leak to a local function that can be inlined.
// ----------------------------------------------------------------------------------------
void leakByteLocalFunction(uint8_t k) { temp &= publicarray2[(k)]; }
void victim_function_v2(size_t x) {
     if (x < publicarray_size) {
          leakByteLocalFunction(publicarray[x]);
     }
}
#endif

#ifdef v3
// ----------------------------------------------------------------------------------------
// EXAMPLE 3:  Moving the leak to a function that cannot be inlined.
//
// Comments: Output is unsafe.  The same results occur if leakByteNoinlineFunction()
// is in another source module.
// ----------------------------------------------------------------------------------------
__declspec(noinline) void leakByteNoinlineFunction(uint8_t k) { temp &= publicarray2[(k)]; }
void victim_function_v3(size_t x) {
     if (x < publicarray_size)
          leakByteNoinlineFunction(publicarray[x]);
}
#endif

#ifdef v4
// ----------------------------------------------------------------------------------------
// EXAMPLE 4:  Add a left shift by one on the index.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v4(size_t x) {
     if (x < publicarray_size)
          temp &= publicarray2[publicarray[x << 1]];
}
#endif

#ifdef v5
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
#endif

#ifdef v6
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
#endif

#ifdef v7
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
#endif

#ifdef v8
// ----------------------------------------------------------------------------------------
// EXAMPLE 8:  Use a ?: operator to check bounds.
// ----------------------------------------------------------------------------------------
void victim_function_v8(size_t x) {
     temp &= publicarray2[publicarray[x < publicarray_size ? (x + 1) : 0]];
}
#endif

#ifdef v9
// ----------------------------------------------------------------------------------------
// EXAMPLE 9:  Use a separate value to communicate the safety check status.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v9(size_t x, int *x_is_safe) {
     if (*x_is_safe)
          temp &= publicarray2[publicarray[x]];
}
#endif

#ifdef v10
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
#endif

#ifdef v11
// ----------------------------------------------------------------------------------------
// EXAMPLE 11:  Use memcmp() to read the memory for the leak.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
int mymemcmp(const void *cs, const void *ct, int count)
{
    const unsigned char *su1, *su2;
    int res = 0;

    for (su1 = cs, su2 = ct; 0 < count; ++su1, ++su2, count--) {
        if ((res = *su1 - *su2) != 0) {
            break;
        }
    }
    return res;
}
void victim_function_v11(size_t x) {
     if (x < publicarray_size)
          temp = mymemcmp(&temp, publicarray2 + (publicarray[x]), 1);
}
#endif

#ifdef v12
// ----------------------------------------------------------------------------------------
// EXAMPLE 12:  Make the index be the sum of two input parameters.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v12(size_t x, size_t y) {
     if ((x + y) < publicarray_size)
          temp &= publicarray2[publicarray[x + y]];
}
#endif

#ifdef v13
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
#endif

#ifdef v14
// ----------------------------------------------------------------------------------------
// EXAMPLE 14:  Invert the low bits of x
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v14(size_t x) {
     if (x < publicarray_size)
          temp &= publicarray2[publicarray[x ^ 255]];
}
#endif

#ifdef v15
// ----------------------------------------------------------------------------------------
// EXAMPLE 15:  Pass a pointer to the length
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v15(size_t *x) {
     if (*x < publicarray_size)
          temp &= publicarray2[publicarray[*x]];
}
#endif

#ifndef spectector
int main()
{
    size_t x;
    int y;
    
    #ifdef klee
    klee_make_symbolic(&x, sizeof(x), "x");
    klee_make_symbolic(&y, sizeof(y), "y");
    #endif
    
    #ifdef zombmc
    x = __VERIFIER_nondet_long();
    y = __VERIFIER_nondet_int();
    #endif 

    #ifdef v1
    victim_function_v1(x);
    #endif
    #ifdef v2
    victim_function_v2(x);
    #endif
    #ifdef v3
    victim_function_v3(x);
    #endif
    #ifdef v4
    victim_function_v4(x);
    #endif
    #ifdef v5
    victim_function_v5(x);
    #endif
    #ifdef v6
    victim_function_v6(x);
    #endif
    #ifdef v7
    victim_function_v7(x);
    #endif
    #ifdef v8
    victim_function_v8(x);
    #endif
    #ifdef v9
    victim_function_v9(x,&y);
    #endif
    #ifdef v10
    victim_function_v10(x,10);
    #endif
    #ifdef v11
    victim_function_v11(x);
    #endif
    #ifdef v12
    victim_function_v12(x,x);
    #endif
    #ifdef v13
    victim_function_v13(x);
    #endif
    #ifdef v14
    victim_function_v14(x);
    #endif
    #ifdef v15
    victim_function_v15(&x);
    #endif
    return 0;
}
#endif
