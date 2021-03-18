package com.dat3m.dartagnan.program.assembler.event;

import com.dat3m.dartagnan.expression.IExpr;
import com.dat3m.dartagnan.program.Register;
import com.dat3m.dartagnan.program.event.Load;

public class PopLoad extends Load {

	public PopLoad(Register register, IExpr address) {
		super(register, address, "NA");
	}

	@Override
	public String toString() {
		return getResultRegister() + " <- pop() // reading from " + address;
	}
}
