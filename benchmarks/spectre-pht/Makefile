CC=clang
CFLAGS=-m32 -S -mllvm --x86-asm-syntax=intel -fdeclspec -fomit-frame-pointer

# Compilation

all: spectre-pht.s spectre-pht-lfence.s spectre-pht-slh.s

.DEFAULT_GOAL := all

spectre-pht.s : spectre-pht.c
	$(CC) $(CFLAGS) $< -o $@

spectre-pht-lfence.s : spectre-pht.c
	$(CC) $(CFLAGS) -mllvm -x86-speculative-load-hardening -mllvm -x86-slh-lfence $< -o $@

spectre-pht-slh.s : spectre-pht.c
	$(CC) $(CFLAGS) -mllvm -x86-speculative-load-hardening -Dslh $< -o $@

clean :
	rm spectre-pht.s spectre-pht-lfence.s spectre-pht-slh.s
