package com.dat3m.dartagnan.parsers.program.visitors.utils;

public enum X86Registers {
	RAX, RBX, RCX, RDX, RDI, RBP, RSP, RSI,
	EAX, EBX, ECX, EDX, EDI, EBP, ESP, ESI,
	AX, BX, CX, DX, DI, BP, SP, SI,
	AH, AL, BH, BL, CH, CL, DH, DL, SPL, BPL, SIL, DIL, 
	R8, R8D, R8W, R8B,
	R9, R9D, R9W, R9B,
	R10, R10D, R10W, R10B,
	R11, R11D, R11W, R11B,
	R12, R12D, R12W, R12B,
	R13, R13D, R13W, R13B,
	R14, R14D, R14W, R14B,
	R15, R15D, R15W, R15B,
	CI, IP, CS, DS, ES, SS;
	
	public String getName() {
		return toString().toLowerCase();
	}
}
