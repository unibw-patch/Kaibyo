#include <string.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

#ifdef zombmc
extern uint32_t __VERIFIER_nondet_int(void);
#endif

uint32_t publicarray_size = 16;
uint8_t publicarray[16] = { 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 };
uint8_t publicarray2[16] = {20,20,20,20,20,20,20,20,20,20,20,20,20,20,20,20};

// The attacker's goal in all of these examples is to learn any of the secret data in secretarray
uint32_t secretarray_size = 16;
uint8_t secretarray[16] = { 10,21,32,43,54,65,76,87,98,109,110,121,132,143,154,165 };

// this is mostly used to prevent the compiler from optimizing out certain operations
volatile uint8_t temp = 0;

uint32_t idxg;

#ifdef v1
// ----------------------------------------------------------------------------------------
/* Based on original POC for Spectre-v4 */
/* https://github.com/IAIK/transientfail/blob/master/pocs/spectre/STL/main.c */
// ----------------------------------------------------------------------------------------
void victim_function_v1(uint32_t idx) {  /* INSECURE */
    uint32_t ridx = idx & (secretarray_size - 1);

    uint8_t* data = secretarray;
    uint8_t** data_slowptr = &data;
    uint8_t*** data_slowslowptr = &data_slowptr;
  
    /* Overwrite secret value */
    (*(*data_slowslowptr))[ridx] = 0; // Bypassed store
  
    /* Access overwritten secret */
    temp &= publicarray2[secretarray[ridx]];
}
#endif

#ifdef v2
// ----------------------------------------------------------------------------------------
/* Discalaimer: The following test cases are probably not vulnerable
   to Spectre-STL attacks because the stored that are supposed to be
   bypassed are fast. They can however be adapted following the method
   in case_1 to slow down the store to bypass. */

/* The example is insecure because index masking is compiled to a
   store that can be bypassed */
// ----------------------------------------------------------------------------------------
void victim_function_v2(uint32_t idx) {  /* INSECURE */
    idxg = idx & (publicarray_size - 1);
      
    /* Access overwritten secret */
    temp &= publicarray2[publicarray[idxg]];
}
#endif

#ifdef v3
// ----------------------------------------------------------------------------------------
/* Same example as before but the index is put in a register so the
   example is now secure */
// ----------------------------------------------------------------------------------------
void victim_function_v3(uint32_t idx) {  // SECURE
    uint32_t ridx = idx & (publicarray_size - 1);
      
    /* Access overwritten secret */
    temp &= publicarray2[publicarray[ridx]];  }
#endif

#ifdef v4
/* In the following examples the index is put in a register so the
   masking is never bypassed */

/* Similar to case_1 but without intermediate pointers */
void victim_function_v4(uint32_t idx) { // INSECURE
  uint32_t ridx = idx & (publicarray_size - 1);

  /* Overwrite secret value */
  secretarray[ridx] = 0;  // Bypassed store
  
  /* Access overwritten secret */
  temp &= publicarray2[secretarray[ridx]];
}
#endif

#ifdef v5
uint8_t *case5_ptr = secretarray;
void victim_function_v5(uint32_t idx) { // INSECURE
    uint32_t ridx = idx & (publicarray_size - 1);

    case5_ptr = publicarray;       // Bypassed store

    uint8_t toleak = case5_ptr[ridx];
    temp &= publicarray2[toleak];
}
#endif

#ifdef v6
uint32_t case6_idx = 0;
uint8_t *case6_array[2] = { secretarray, publicarray };
void victim_function_v6(uint32_t idx) { // INSECURE
  uint32_t ridx = idx & (publicarray_size - 1);

  case6_idx = 1;       // Bypassed store

  uint8_t toleak = (case6_array[case6_idx])[ridx];
  temp &= publicarray2[toleak];
}
#endif

#ifdef v7
uint32_t case7_mask = UINT32_MAX;
void victim_function_v7(uint32_t idx) {  // INSECURE
  case7_mask = (publicarray_size - 1); // Bypassed store

  uint8_t toleak = publicarray[idx & case7_mask];
  temp &= publicarray2[toleak];
}
#endif

#ifdef v8
uint32_t case8_mult = 200;
void victim_function_v8(uint32_t idx) {  // INSECURE
  case8_mult = 0; // Bypassed store

  uint8_t toleak = publicarray[idx * case8_mult];
  temp &= publicarray2[toleak];
}
#endif

#ifdef v9
/* This store should be secure assuming no speculation on conditionals
   because when the programs fetches the last line, the store that
   overwrites the secret should be retired. */
void victim_function_v9(uint32_t idx) {  // SECURE
  uint32_t ridx = idx & (publicarray_size - 1);

  /* Overwrite secret value */
  secretarray[ridx] = 0;  // Bypassed store
  
  for (uint32_t i = 0; i < 200; ++i) temp &= i;
  
  /* Access overwritten secret */
  temp &= publicarray2[secretarray[ridx]];
}
#endif

#ifdef v10
/* Same as case 3 (secure) but masking is made by a function call */
uint32_t case_10_mask(uint32_t idx) {
  uint32_t ridx = idx & (publicarray_size - 1);
  return ridx;
}
void victim_function_v10(uint32_t idx) { // SECURE
  uint32_t fidx = case_10_mask(idx);
  
  /* Access overwritten secret */
  temp &= publicarray2[publicarray[fidx]];
}
#endif

#ifdef v11
/* Same as case 3 (secure) but first load is made by a function call */
uint8_t case_11_load_value(uint32_t idx) {
  uint32_t ridx = idx & (publicarray_size - 1);
  uint8_t to_leak = publicarray[ridx];
  return to_leak;
}
void victim_function_v11(uint32_t idx) { // SECURE
  uint8_t to_leak = case_11_load_value(idx);

  /* Access overwritten secret */
  temp &= publicarray2[to_leak];
}
#endif

#ifdef v12
/* Same as 10 but result of function is in register */
uint32_t case_12_mask(uint32_t idx) {
  uint32_t ridx = idx & (publicarray_size - 1);
  return ridx;
}
void victim_function_v12(uint32_t idx) { // SECURE
  uint32_t ridx = case_12_mask(idx);
  
  /* Access overwritten secret */
  temp &= publicarray2[publicarray[ridx]];
}
#endif

#ifdef v13
/* Same as case 10 but result of function is in register */
uint8_t case_13_load_value(uint32_t idx) {
  uint32_t ridx = idx & (publicarray_size - 1);
  uint8_t to_leak = publicarray[ridx];
  return to_leak;
}
void victim_function_v13(uint32_t idx) {  // SECURE
  uint8_t to_leak = case_13_load_value(idx);

  /* Access overwritten secret */
  temp &= publicarray2[to_leak];
}
#endif

int main()
{
    uint32_t x = 0;
    
    #ifdef zombmc
    idxg = __VERIFIER_nondet_int();
    x = __VERIFIER_nondet_int();
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
    victim_function_v9(x);
    #endif
    #ifdef v10
    victim_function_v10(x);
    #endif
    #ifdef v11
    victim_function_v11(x);
    #endif
    #ifdef v12
    victim_function_v12(x);
    #endif
    #ifdef v13
    victim_function_v13(x);
    #endif
    return 0;
}
