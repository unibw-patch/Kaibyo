CC=gcc
CFLAGS=-m32 -masm=intel -fomit-frame-pointer  -fno-stack-protector -static -no-pie -fno-pic

# Compilation

all: spectre-stl spectre-stl.s

.DEFAULT_GOAL := all

spectre-stl : spectre-stl.c
	$(CC) $(CFLAGS) $< -o $@

spectre-stl.s : spectre-stl.c
	$(CC) -S $(CFLAGS) $< -o $@

clean :
	rm spectre-stl spectre-stl.s
