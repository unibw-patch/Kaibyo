package com.dat3m.dartagnan.program.assembler.event;

import com.dat3m.dartagnan.expression.ExprInterface;
import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.event.Store;

public class PushStore extends Store {

	public PushStore(IExpr address, ExprInterface value) {
		super(address, value, "NA");
	}

	@Override
	public String toString() {
		return "push(" + value +") // storing to " + address;
	}
}
