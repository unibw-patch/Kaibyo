// Set of litmus tests for Spectre-v4

#include <stdint.h>
#include <stddef.h>

#ifdef zombmc
extern uint32_t __VERIFIER_nondet_uint(void);
#endif

#define SIZE 16                 /* Size fo secretarray and publicarray */
uint32_t array_size = SIZE;

uint32_t publicarray[SIZE] = { 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 };
uint32_t publicarray2[16] = { 20 };

// The attacker's goal in all of these examples is to learn any of the secret data in secretarray
uint32_t secretarray[SIZE] __attribute__((used)) = { 10,21,32,43,54,65,76,87,98,109,110,121,132,143,154,165 };


// this is mostly used to prevent the compiler from optimizing out certain operations
volatile uint32_t temp = 0;

uint32_t idxg;

#ifdef f2
void figure_2(uint32_t idx) {  /* INSECURE */
    uint32_t s = 2;
    secretarray[idx] = s;
    temp &= publicarray2[publicarray[0]];
}
#endif

#ifdef f7
void figure_7(uint32_t idx) {  /* INSECURE */
    uint32_t secret = secretarray[0];
    if (idx < array_size) {
        secretarray[idx] = secret;
    }
    temp &= publicarray2[publicarray[idx]];
}
#endif

int main()
{
    uint32_t x = 0;
    
    #ifdef zombmc
    idxg = __VERIFIER_nondet_uint();
    x = __VERIFIER_nondet_uint();
    #endif
    
    #ifdef f2
    figure_2(x);
    #endif
    #ifdef f7
    figure_7(x);
    #endif

    return 0;
}
