CC=gcc
CFLAGS=-m32 -march=i386 -fno-stack-protector -no-pie -fno-pic

.PHONY: clean spectre-pht spectre-stl

# Compilation

spectre-pht : spectre-pht.c
	$(CC) $(CFLAGS) $< -o $@

Spectre-stl : spectre-stl.c
	$(CC) $(CFLAGS) $< -o $@

clean :
	rm spectre-pht spectre-stl
