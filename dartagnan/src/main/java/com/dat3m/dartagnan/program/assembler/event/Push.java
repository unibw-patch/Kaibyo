package com.dat3m.dartagnan.program.assembler.event;

import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Event;

public class Push extends Event {

	private Register value;
	
	public Push(Register value) {
		this.value = value; 
	}
	
	public Register getValue() {
		return value;
	}
	
    public void unroll(int bound, Event predecessor) {
    	// This is only used for AsmX86 parsing and immediately convert to something else
        throw new RuntimeException("Unrolling of Push events is not possible");
    }
}
