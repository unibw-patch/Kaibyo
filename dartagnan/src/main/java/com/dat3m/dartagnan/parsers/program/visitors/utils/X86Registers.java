package com.dat3m.dartagnan.parsers.program.visitors.utils;

public enum X86Registers {
	AH, AL, BH, BL, CH, CL, DH, DL, AX, BX, CX, DX, CI, DI, BP, SP, IP, CS, DS, ES, SS, 
	EAX, EBX, ECX, EDX, EDI, EBP, ESP, ESI,
	RAX, RBX, RCX, RDX, RDI, RBP, RSP, RSI,
	CF;
	
	public String getName() {
		return toString().toLowerCase();
	}
}
