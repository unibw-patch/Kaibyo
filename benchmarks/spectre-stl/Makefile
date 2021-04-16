CC=gcc
CFLAGS=-m32 -S -masm=intel -fomit-frame-pointer -fno-pic

.PHONY: clean spectre-stl.s

# Compilation

spectre-stl.s : spectre-stl.c
	$(CC) $(CFLAGS) $< -o $@

clean :
	rm spectre-stl.s
