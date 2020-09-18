#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

#ifdef klee
#include <klee/klee.h>
#endif

#ifndef spectector
#ifndef klee
extern size_t __VERIFIER_nondet_long(void);
extern int __VERIFIER_nondet_int(void);
#endif
#endif

#define SIZE    (1)
#define LOOP    (10)

unsigned int array1_size = 16;
uint8_t array1[16] = {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16};
uint8_t array2[256 * SIZE];

char * spectre_secret = "The Magic Words are Squeamish Ossifrage.";

uint8_t temp = 0; /* Used so compiler won’t optimize out victim_function() */

#ifdef v01
// ----------------------------------------------------------------------------------------
// EXAMPLE 1:  This is the sample function from the Spectre paper.
// ----------------------------------------------------------------------------------------
void victim_function_v01(size_t x) {
    for (int i = 1; i < LOOP; ++i) {
        if(i == LOOP - 1) {
            if (x < array1_size) {
                temp &= array2[array1[x] * SIZE];
            }
        }
    }
}
#endif

#ifdef v02
// ----------------------------------------------------------------------------------------
// EXAMPLE 2:  Moving the leak to a local function that can be inlined.
// ----------------------------------------------------------------------------------------
void leakByteLocalFunction(uint8_t k) { temp &= array2[(k)* SIZE]; }
void victim_function_v02(size_t x) {
    for (int i = 1; i < LOOP; ++i) {
        if(i == LOOP - 1) {
            if (x < array1_size) {
                leakByteLocalFunction(array1[x]);
            }
        }
    }
}
#endif

#ifdef v03
// ----------------------------------------------------------------------------------------
// EXAMPLE 3:  Moving the leak to a function that cannot be inlined.
//
// Comments: Output is unsafe.  The same results occur if leakByteNoinlineFunction()
// is in another source module.
// ----------------------------------------------------------------------------------------
__declspec(noinline) void leakByteNoinlineFunction(uint8_t k) { temp &= array2[(k)* SIZE]; }
void victim_function_v03(size_t x) {
    for (int i = 1; i < LOOP; ++i) {
        if(i == LOOP - 1) {
            if (x < array1_size)
                leakByteNoinlineFunction(array1[x]);
        }
    }
}
#endif

#ifdef v04
// ----------------------------------------------------------------------------------------
// EXAMPLE 4:  Add a left shift by one on the index.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v04(size_t x) {
    for (int i = 1; i < LOOP; ++i) {
        if(i == LOOP - 1) {
            if (x < array1_size)
                temp &= array2[array1[x << 1] * SIZE];
        }
    }
}
#endif

#ifdef v05
// ----------------------------------------------------------------------------------------
// EXAMPLE 5:  Use x as the initial value in a for() loop.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v05(size_t x) {
     int i;
    for (int i = 1; i < LOOP; ++i) {
        if(i == LOOP - 1) {
            if (x < array1_size) {
                for (i = x - 1; i >= 0; i--) {
                    temp &= array2[array1[i] * SIZE];
                }
            }
        }
    }
}
#endif

#ifdef v06
// ----------------------------------------------------------------------------------------
// EXAMPLE 6:  Check the bounds with an AND mask, rather than "<".
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
int array_size_mask = 15;
void victim_function_v06(size_t x) {
    for (int i = 1; i < LOOP; ++i) {
        if(i == LOOP - 1) {
            if ((x & array_size_mask) == x)
                temp &= array2[array1[x] * SIZE];
        }
    }
}
#endif

#ifdef v07
// ----------------------------------------------------------------------------------------
// EXAMPLE 7:  Compare against the last known-good value.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v07(size_t x) {
     static size_t last_x = 0;
    for (int i = 1; i < LOOP; ++i) {
        if(i == LOOP - 1) {
            if (x == last_x)
                temp &= array2[array1[x] * SIZE];
            if (x < array1_size)
                last_x = x;
        }
    }
}
#endif

#ifdef v08
// ----------------------------------------------------------------------------------------
// EXAMPLE 8:  Use a ?: operator to check bounds.
// ----------------------------------------------------------------------------------------
void victim_function_v08(size_t x) {
    for (int i = 1; i < LOOP; ++i) {
        if(i == LOOP - 1) {
            temp &= array2[array1[x < array1_size ? (x + 1) : 0] * SIZE];
        }
    }
}
#endif

#ifdef v09
// ----------------------------------------------------------------------------------------
// EXAMPLE 9:  Use a separate value to communicate the safety check status.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v09(size_t x, int *x_is_safe) {
    for (int i = 1; i < LOOP; ++i) {
        if(i == LOOP - 1) {
            if (*x_is_safe)
                temp &= array2[array1[x] * SIZE];
        }
    }
}
#endif

#ifdef v10
// ----------------------------------------------------------------------------------------
// EXAMPLE 10:  Leak a comparison result.
//
// Comments: Output is unsafe.  Note that this vulnerability is a little different, namely
// the attacker is assumed to provide both x and k.  The victim code checks whether
// array1[x] == k.  If so, the victim reads from array2[0].  The attacker can try
// values for k until finding the one that causes array2[0] to get brought into the cache.
// ----------------------------------------------------------------------------------------
void victim_function_v10(size_t x, uint8_t k) {
    for (int i = 1; i < LOOP; ++i) {
        if(i == LOOP - 1) {
            if (x < array1_size) {
                if (array1[x] == k)
                    temp &= array2[0];
            }
        }
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
    for (int i = 1; i < LOOP; ++i) {
        if(i == LOOP - 1) {
            if (x < array1_size)
                temp = mymemcmp(&temp, array2 + (array1[x] * SIZE), 1);
        }
    }
}
#endif

#ifdef v12
// ----------------------------------------------------------------------------------------
// EXAMPLE 12:  Make the index be the sum of two input parameters.
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v12(size_t x, size_t y) {
     if ((x + y) < array1_size)
          temp &= array2[array1[x + y] * SIZE];
}
#endif

#ifdef v13
// ----------------------------------------------------------------------------------------
// EXAMPLE 13:  Do the safety check into an inline function
//
// Comments: Output is unsafe. We removed the "__inline" since anyways BMC inlines all the calls
// ----------------------------------------------------------------------------------------
int is_x_safe(size_t x) {
    if (x < array1_size) {
        return 1;
    }
    return 0;
}
void victim_function_v13(size_t x) {
    for (int i = 1; i < LOOP; ++i) {
        if(i == LOOP - 1) {
            if (is_x_safe(x))
                temp &= array2[array1[x] * SIZE];
        }
    }
}
#endif

#ifdef v14
// ----------------------------------------------------------------------------------------
// EXAMPLE 14:  Invert the low bits of x
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v14(size_t x) {
     if (x < array1_size)
          temp &= array2[array1[x ^ 255] * SIZE];
}
#endif

#ifdef v15
// ----------------------------------------------------------------------------------------
// EXAMPLE 15:  Pass a pointer to the length
//
// Comments: Output is unsafe.
// ----------------------------------------------------------------------------------------
void victim_function_v15(size_t *x) {
    for (int i = 1; i < LOOP; ++i) {
        if(i == LOOP - 1) {
            if (*x < array1_size)
                temp &= array2[array1[*x] * SIZE];
        }
    }
}
#endif

#ifndef spectector
int main()
{
    #ifdef klee
    size_t x;
    klee_make_symbolic(&x, sizeof(x), "x");
    int y;
    klee_make_symbolic(&y, sizeof(y), "y");
    #else
    size_t x = __VERIFIER_nondet_long();
    int y = __VERIFIER_nondet_int();
    #endif

    #ifdef v01
    victim_function_v01(x);
    #endif
    #ifdef v02
    victim_function_v02(x);
    #endif
    #ifdef v03
    victim_function_v03(x);
    #endif
    #ifdef v04
    victim_function_v04(x);
    #endif
    #ifdef v05
    victim_function_v05(x);
    #endif
    #ifdef v06
    victim_function_v06(x);
    #endif
    #ifdef v07
    victim_function_v07(x);
    #endif
    #ifdef v08
    victim_function_v08(x);
    #endif
    #ifdef v09
    victim_function_v09(x,&y);
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
