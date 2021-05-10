//
// Similar to Paul Kockers’s set of litmus tests for Spectre-PHT
// (https://www.paulkocher.com/doc/MicrosoftCompilerSpectreMitigation.html), we
// propose a new set of litmus tests for Spectre-SLT.
//
// This set of litmus test follows the same philosophy as the adaptation of the
// litmus test for Spectre-PHT from Pitchfork:
// https://github.com/cdisselkoen/pitchfork/blob/master/new-testcases/spectrev1.c
//
// In particular:
// - The programs are intended to be constant-time in the regular (in-order)
//   execution.
// - Load indexes and control-flow statement can leak secret data
// - Secret input is explicitely defined in `secretarray`` and the goal of the
//   attacker is to leak data from this array
//
#include <stdint.h>
#include <stddef.h>

#define SIZE 16                 /* Size fo secretarray and publicarray */
uint32_t array_size = 16;

// Public values
uint8_t publicarray[SIZE] = { 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15 };
uint8_t publicarray2[SIZE] = { 20 };

// The attacker's goal in all of these examples is to learn any of the secret data in secretarray
uint8_t secretarray[SIZE] __attribute__((used)) = { 10,21,32,43,54,65,76,87,98,109,110,121,132,143,154,165 };

// This is mostly used to prevent the compiler from optimizing out certain operations
volatile uint8_t temp = 0;

// In all of these examples, the arguments to the functions are attacker-controlled
//
// Examples marked as _insecure_ (resp. _secure_) violate (resp. are secure
// w.r.t) Speculative Constant-Time (SCT) when compiled with gcc-10.2.0 -O0 -m32
// -march=i386 -fno-stack-protector -static -no-pie -fno-pic
//
// Note however that SCT is a conservative property: a program that is secure
// w.r.t to SCT is free from Spectre attacks but a program that violates SCT is
// not necessarilly vulnerable to Spectre attacks


// Case 1: _insecure_
//
// Based on original POC for Spectre-v4,
// https://github.com/IAIK/transientfail/blob/master/pocs/spectre/STL/main.c
void victim_function_v1(uint32_t idx) {
  register uint32_t ridx asm ("edx");
  ridx = idx & (array_size - 1);

  uint8_t* data = secretarray;
  uint8_t** data_slowptr = &data;
  uint8_t*** data_slowslowptr = &data_slowptr;
  
  /* Overwrite secret value */
  (*(*data_slowslowptr))[ridx] = 0; // Bypassed store
  
  /* Access overwritten secret */
  temp &= publicarray2[secretarray[ridx]];
}


// Case 2: _insecure_
//
// Array access protected by index masking: this test case is insecure because
// the masked index is stored on the stack and therefore can be bypassed
void victim_function_v2(uint32_t idx) {
  idx = idx & (array_size - 1);

  // Bypassed store is not visible at source level

  /* Access overwritten secret */
  temp &= publicarray2[publicarray[idx]];
}


// Case 3: _secure_
//
// Same as victim_function_v2 but the index is forced into a register so the example is now
// secure
void victim_function_v3(uint32_t idx) {
  register uint32_t ridx asm ("edx");
  ridx = idx & (array_size - 1);
  
  /* Access overwritten secret */
  temp &= publicarray2[publicarray[ridx]];
}
// In the following examples the index is put in a register so masking is not
// bypassed


// Case 4: _insecure_
//
// Similar to victim_function_v1 but without intermediate pointers
void victim_function_v4(uint32_t idx) {
  register uint32_t ridx asm ("edx");
  ridx = idx & (array_size - 1);

  /* Overwrite secret value */
  secretarray[ridx] = 0;        // Bypassed store
  
  /* Access overwritten secret */
  temp &= publicarray2[secretarray[ridx]];
}


// Case 5: _insecure_
//
// Overwrite private pointer with public pointer
uint8_t *case5_ptr = secretarray;
void victim_function_v5(uint32_t idx) {
  register uint32_t ridx asm ("edx");
  ridx = idx & (array_size - 1);

  case5_ptr = publicarray;      // Bypassed store

  uint8_t toleak = case5_ptr[ridx];
  temp &= publicarray2[toleak];
}


// Case 6: _insecure_
//
// Overwrite index to a table
uint32_t case6_idx = 0;
uint8_t *case6_array[2] = { secretarray, publicarray };
void victim_function_v6(uint32_t idx) {
  register uint32_t ridx asm ("edx");
  ridx = idx & (array_size - 1);

  case6_idx = 1;                // Bypassed store

  uint8_t toleak = (case6_array[case6_idx])[ridx];
  temp &= publicarray2[toleak];
}


// Case 6: _insecure_
//
// Same as victim_function_v2 but the mask is put in a variable
uint32_t case7_mask = UINT32_MAX;
void victim_function_v7(uint32_t idx) {
  case7_mask = (array_size - 1); // Bypassed store

  uint8_t toleak = publicarray[idx & case7_mask];
  temp &= publicarray2[toleak];
}


// Case 8: _insecure_
//
// Index is multiplied by 0 to avoid overflows
uint32_t case8_mult = 200;
void victim_function_v8(uint32_t idx) {
  case8_mult = 0;               // Bypassed store

  uint8_t toleak = publicarray[idx * case8_mult];
  temp &= publicarray2[toleak];
}


// Case 9: _secure_
//
// Same as victim_function_v4 but the store should not be bypassed assuming no speculation
// on conditionals. When the programs fetches the last line, the store that
// overwrites the secret should be retired because the sequence of instruction
// of the for loop is longer than the the reorder buffer.
void victim_function_v9(uint32_t idx) {
  register uint32_t ridx asm ("edx");
  ridx = idx & (array_size - 1);

  /* Overwrite secret value */
  secretarray[ridx] = 0;        // *Not* bypassed store
  
  register uint32_t i asm ("ecx");
  for (i = 0; i < 200; ++i) temp &= i;
  
  /* Access overwritten secret */
  temp &= publicarray2[secretarray[ridx]];
}


// Case 9_bis: _insecure_
//
// Same as victim_function_v9 but this time the loop is too short. The store is not retired
// yet store is not retired yet when the load is executed and can therefore be
// bypassed.
void victim_function_v9_bis(uint32_t idx) {
  register uint32_t ridx asm ("edx");
  ridx = idx & (array_size - 1);

  /* Overwrite secret value */
  secretarray[ridx] = 0;        // Bypassed store
  
  register uint32_t i asm ("ecx");
  for (i = 0; i < 10; ++i) temp &= i;
  
  /* Access overwritten secret */
  temp &= publicarray2[secretarray[ridx]];
}


// Case 10: _insecure_
//
// Same as victim_function_v3 but masking is made by a function call. Because returned value
// is pushed on the stack, it can also be bypassed. */
uint32_t victim_function_v10_do_mask(uint32_t idx) {
  register uint32_t ridx asm ("edx");
  ridx = idx & (array_size - 1);
  return ridx;
}
void victim_function_v10(uint32_t idx) {
  uint32_t fidx = victim_function_v10_do_mask(idx);
  
  /* Access overwritten secret */
  temp &= publicarray2[publicarray[fidx]];
}


// Case 11: _insecure_
//
// Same as victim_function_v3 but masking load is made by a function call. Because returned
// value is pushed on the stack, it can also be bypassed. */
uint8_t victim_function_v11_load_value(uint32_t idx) {
  register uint32_t ridx asm ("edx");
  ridx = idx & (array_size - 1);
  uint8_t to_leak = publicarray[ridx];
  return to_leak;
}
void victim_function_v11(uint32_t idx) {
  uint8_t to_leak = victim_function_v11_load_value(idx);

  /* Access overwritten secret */
  temp &= publicarray2[to_leak];
}


// Case 12: _secure_
//
// Same as 10 but result of function is forced in register so it cannot be
// bypassed
void victim_function_v12(uint32_t idx) {
  register uint32_t ridx asm ("edx");
  ridx = victim_function_v10_do_mask(idx);
  
  /* Access overwritten secret */
  temp &= publicarray2[publicarray[ridx]];
}


// Case 13: _secure_
//
// Same as 11 but result of function is forced in register so it cannot be
// bypassed
void victim_function_v13(uint32_t idx) {  // SECURE
  register uint8_t to_leak asm ("edx");
  to_leak = victim_function_v11_load_value(idx);

  /* Access overwritten secret */
  temp &= publicarray2[to_leak];
}


int main() {
    return 0;
}
