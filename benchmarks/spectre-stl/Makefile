CC=gcc
CFLAGS=-m32 -march=i386 -fomit-frame-pointer

.PHONY: clean spectre-stl

# Compilation

spectre-stl : spectre-stl.c
	$(CC) $(CFLAGS) $< -o $@

clean :
	rm spectre-stl
