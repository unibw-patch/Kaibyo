CC=gcc
CFLAGS=-m32 -masm=intel -fomit-frame-pointer  -fno-stack-protector -static -no-pie -fno-pic

.PHONY: clean spectre-stl.s

# Compilation

spectre-stl.s : spectre-stl.c
	$(CC) $(CFLAGS) $< -o $@

spectre-stl.s : spectre-stl.c
	$(CC) -S $(CFLAGS) $< -o $@

clean :
	rm spectre-stl.s
