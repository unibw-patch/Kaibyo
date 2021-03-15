package com.dat3m.dartagnan.program.assembler.event;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class Pop extends Event {

	private Register reg;
	
	public Pop(Register reg) {
		this.reg = reg; 
	}
	
	public Register getRegister() {
		return reg;
	}
	
    public void unroll(int bound, Event predecessor) {
    	// This is only used for AsmX86 parsing and immediately convert to something else
        throw new RuntimeException("Unrolling of Pop events is not possible");
    }
}
