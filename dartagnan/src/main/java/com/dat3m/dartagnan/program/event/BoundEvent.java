package com.dat3m.dartagnan.program.event;

import com.dat3m.dartagnan.program.utils.EType;
import com.microsoft.z3.Context;

public class BoundEvent extends Event {

	public BoundEvent() {
		super();
        addFilters(EType.ANY, EType.BOUND);
	}
	
	protected BoundEvent(BoundEvent other){
		super(other);
	}

	@Override
	public String toString() {
		return "boundEvent()";
	}
	
	@Override
	public BoundEvent getCopy(){
		return new BoundEvent(this);
	}
	
	// Encoding
	// -----------------------------------------------------------------------------------------------------------------

	@Override
	public void initialise(Context ctx){
		if(cId < 0){
			throw new RuntimeException("Event ID is not set in " + this);
		}
		execVar = ctx.mkBoolConst("exec(" + repr() + ")");
		cfVar = ctx.mkBoolConst("cf(" + repr() + ")");
		seVar = ctx.mkFalse();
		startSEVar = ctx.mkFalse();;
	}
}
