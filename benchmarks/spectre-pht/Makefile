CC=clang
CFLAGS=-m32 -S -mllvm --x86-asm-syntax=intel -fdeclspec -fomit-frame-pointer

.PHONY: clean spectre-pht spectre-pht-lfence spectre-pht-slh

# Compilation

spectre-pht : spectre-pht.c
	$(CC) $(CFLAGS) $< -o $@

spectre-pht-lfence : spectre-pht.c
	$(CC) $(CFLAGS) -mllvm -x86-speculative-load-hardening -mllvm -x86-slh-lfence $< -o $@

spectre-pht-slh : spectre-pht.c
	$(CC) $(CFLAGS) -mllvm -x86-speculative-load-hardening -Dslh $< -o $@

clean :
	rm spectre-pht spectre-pht-lfence spectre-pht-slh
