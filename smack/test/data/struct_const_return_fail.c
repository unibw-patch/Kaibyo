#include "smack.h"

// @flag --clang-options=-O1
// @expect error 

typedef struct {
  int a;
  long b;
} S;

S foo() {
  S x = {1, 2L};
  assert(1);
  return x;
}

int main() {
  S y = foo();
  assert(y.a == 3);
  return 0;
}
