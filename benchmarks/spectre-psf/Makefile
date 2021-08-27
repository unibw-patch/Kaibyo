CC=gcc
CFLAGS=-m32 -masm=intel -fomit-frame-pointer  -fno-stack-protector -static -no-pie -fno-pic

# Compilation

all: spectre-psf spectre-psf.s

.DEFAULT_GOAL := all

spectre-psf : spectre-psf.c
	$(CC) $(CFLAGS) $< -o $@

spectre-psf.s : spectre-psf.c
	$(CC) -S $(CFLAGS) $< -o $@

clean :
	rm spectre-psf spectre-psf.s
