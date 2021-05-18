CC=gcc
CFLAGS=-m32 -masm=intel -fomit-frame-pointer  -fno-stack-protector -static -no-pie -fno-pic

# Compilation

all: spectre-pht spectre-pht.s

.DEFAULT_GOAL := all

spectre-pht : spectre-pht.c
	$(CC) $(CFLAGS) $< -o $@

spectre-pht.s : spectre-pht.c
	$(CC) -S $(CFLAGS) $< -o $@

clean :
	rm spectre-pht spectre-pht.s
