CC=gcc
CFLAGS=-m32 -masm=intel -fomit-frame-pointer  -fno-stack-protector -static -no-pie -fno-pic

# Compilation

all: spectre-pht.s

.DEFAULT_GOAL := all

spectre-pht.s : spectre-pht.c
	$(CC) -S $(CFLAGS) $< -o $@

spectre-pht : spectre-pht.c
	$(CC) $(CFLAGS) $< -o $@

clean :
	rm spectre-pht.s
